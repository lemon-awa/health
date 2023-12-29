import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SetGoalPage extends StatefulWidget {
  final String docID;
  const SetGoalPage({super.key, required this.docID});

  @override
  State<SetGoalPage> createState() => _SetGoalPageState();
}

class _SetGoalPageState extends State<SetGoalPage> {
  final _finalController = TextEditingController();
  final _periodCondroller = TextEditingController();

  @override
  void dispose() {
    _finalController.dispose();
    _periodCondroller.dispose();
    super.dispose();
  }

  Future addGoalDetails(String finalGoal, int period) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.docID)
        .collection('goal')
        .add({
      'final': finalGoal,
      'period': period,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 178, 173, 173),
        // title: Text(
        //   'SET NEW GOAL',
        //   style: TextStyle(fontWeight: FontWeight.bold),
        // ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.flag,
                size: 100,
                color: Color.fromARGB(255, 178, 173, 173),
              ),
              Text(
                'New Goal!',
                style: TextStyle(
                    fontFamily: 'Rubik Doodle Shadow',
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _finalController,
                  decoration: InputDecoration(
                    hintText: 'NEW GOAL',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    fillColor: Color.fromARGB(255, 47, 46, 46),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  controller: _periodCondroller,
                  decoration: InputDecoration(
                    hintText: 'WHEN TO ACHIEVE',
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    fillColor: Color.fromARGB(255, 47, 46, 46),
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addGoalDetails(
              _finalController.text, int.parse(_periodCondroller.text));
          Navigator.pop(context);
        },
        child: Icon(Icons.check_box),
      ),
    );
  }
}
