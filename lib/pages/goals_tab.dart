import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:keeping_fit/goal/sleepTemplate.dart';
import 'package:keeping_fit/goal/sleep_edit.dart';
import 'package:keeping_fit/pages/set_goal_page.dart';

class GoalsTab extends StatefulWidget {
  final String docID;
  const GoalsTab({super.key, required this.docID});

  @override
  State<GoalsTab> createState() => _GoalsTabState();
}

class _GoalsTabState extends State<GoalsTab> {
  List<bool>? _isOpen;
  Future<QuerySnapshot>? _goalsFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshGoals();
    _isOpen = [];
  }

  void refreshGoals() async {
    setState(() {
      // 使用新的Future来强制FutureBuilder重新获取数据
      _goalsFuture = FirebaseFirestore.instance
          .collection('users')
          .doc(widget.docID)
          .collection('goal')
          .get();
    });
  }

  Future<void> deletePlanFromFirebase(
      DocumentSnapshot doc, String planId) async {
    await doc.reference.collection('plans').doc(planId).delete();
    refreshGoals();
  }

  Future<void> deleteGoal(DocumentSnapshot goalDoc) async {
    QuerySnapshot planSnapshot =
        await goalDoc.reference.collection('plans').get();
    for (DocumentSnapshot planDoc in planSnapshot.docs) {
      await planDoc.reference.delete();
    }
    await goalDoc.reference.delete();
    refreshGoals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MY GOAL',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Rubik Doodle Shadow',
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SetGoalPage(
                                docID: widget.docID,
                              )),
                    ).then((_) {
                      refreshGoals();
                    });
                  },
                  backgroundColor: Color.fromARGB(255, 197, 181, 200),
                  mini: true,
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Expanded(
              child: FutureBuilder<QuerySnapshot>(
                  future: _goalsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Text(
                        "Error: ${snapshot.error}",
                        style: TextStyle(color: Colors.white),
                      ));
                    } else if (snapshot.hasData) {
                      snapshot.data!.docs.forEach((thisdoc) async {
                        if (thisdoc['goalName'] == null ||
                            thisdoc['goalName'].isEmpty) {
                          await deleteGoal(thisdoc);
                        }
                      });
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                            child: Text(
                          "No goals found",
                          style: TextStyle(color: Colors.white),
                        ));
                      }
                      if (_isOpen!.isEmpty) {
                        _isOpen = List.generate(snapshot.data!.docs.length,
                            (index) => (index == 0));
                      }
                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: ListView(children: [
                            ExpansionPanelList(
                              expansionCallback: (panelIndex, isExpanded) {
                                setState(() {
                                  _isOpen![panelIndex] = isExpanded;
                                });
                              },
                              children: snapshot.data!.docs
                                  .asMap()
                                  .entries
                                  .map<ExpansionPanel>((entry) {
                                int index = entry.key;
                                QueryDocumentSnapshot doc = entry.value;
                                return ExpansionPanel(
                                  backgroundColor:
                                      Color.fromARGB(179, 239, 219, 236),
                                  headerBuilder:
                                      (BuildContext context, bool isExpanded) {
                                    return ListTile(
                                      title: Row(
                                        children: [
                                          IconButton(
                                            onPressed: () async {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Confrim delete'),
                                                      content: Text(
                                                          'Are you sure to delete this goal includes all plans under it'),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            deleteGoal(doc);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('Delete'),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            icon: Icon(Icons.delete),
                                          ),
                                          Expanded(
                                            child: Text(doc['goalName'],
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 0, 0, 0),
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Rainbow',
                                                    fontSize: 28.0)),
                                          ),
                                        ],
                                      ), // Replace with your document field
                                    );
                                  },
                                  body: FutureBuilder<QuerySnapshot>(
                                    future:
                                        doc.reference.collection('plans').get(),
                                    builder: (context, PlansSnapshot) {
                                      if (PlansSnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      }
                                      if (PlansSnapshot.hasData &&
                                          PlansSnapshot.data!.docs.isNotEmpty) {
                                        return Column(
                                          children: PlansSnapshot.data!.docs
                                              .map((planDoc) {
                                            Map<String, dynamic> plansData =
                                                planDoc.data()
                                                    as Map<String, dynamic>;
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 10.0,
                                                  vertical: 5.0),
                                              decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    136, 239, 205, 221),
                                                border: Border.all(
                                                    color: Colors.grey,
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: ListTile(
                                                title: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        plansData[
                                                                'planContext'] ??
                                                            'No Context',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18.0),
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  SleepEdit(
                                                                      docID: widget
                                                                          .docID,
                                                                      goalID: doc
                                                                          .id)),
                                                        ).then((_) {
                                                          refreshGoals();
                                                        });
                                                        // print(doc.id);
                                                      },
                                                      icon: Icon(Icons.edit),
                                                    ),
                                                    IconButton(
                                                      onPressed: () async {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "Confirm Delete"),
                                                                content: Text(
                                                                    'Are you sure you want to delete this plan'),
                                                                actions: <Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Cancel'),
                                                                  ),
                                                                  TextButton(
                                                                    child: Text(
                                                                        "Delete"),
                                                                    onPressed:
                                                                        () {
                                                                      deletePlanFromFirebase(
                                                                          doc,
                                                                          planDoc
                                                                              .id);
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      icon: Icon(Icons.delete),
                                                    ),
                                                  ],
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        'Plan Times: ${plansData['minimumCompletion'].toString()},Completed Times:${plansData['complete'].toString()}'),
                                                    Text(
                                                        'due date: ${DateFormat('yyyy-MM-dd').format(plansData['whenToEnd'].toDate())}'),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        );
                                      }
                                      return Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            'No plan exists',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.0),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SleepEdit(
                                                            docID: widget.docID,
                                                            goalID: doc.id)),
                                              ).then((_) {
                                                refreshGoals();
                                              });
                                            },
                                            icon: Icon(Icons.edit),
                                          ),
                                        ],
                                      ));
                                    },
                                  ),
                                  isExpanded: _isOpen![index],
                                );
                              }).toList(),
                              // Replace with your document field
                              // Add other fields or widgets as needed
                            ),
                          ]));
                    } else {
                      return Center(child: Text("No data available"));
                    }
                  }))
        ],
      ),
    );
  }
}
