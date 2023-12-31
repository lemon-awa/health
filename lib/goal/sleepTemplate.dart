import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class sleepTemplatePage extends StatefulWidget {
  final String docID;
  const sleepTemplatePage({super.key, required this.docID});

  @override
  State<sleepTemplatePage> createState() => _sleepTemplatePageState();
}

class PlanDetails {
  String planContext;
  DateTime whenToEnd;
  int mintimes;

  PlanDetails({
    this.planContext = '',
    required this.whenToEnd,
    this.mintimes = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'planContext': planContext,
      'whenToEnd': whenToEnd,
      'minimumCompletion': mintimes,
    };
  }
}

class _sleepTemplatePageState extends State<sleepTemplatePage> {
  final _goalNameController = TextEditingController();
  List<PlanDetails> plans = [];

  @override
  void dispose() {
    _goalNameController.dispose();
    super.dispose();
  }

  void addPlan() {
    setState(() {
      plans.add(PlanDetails(whenToEnd: DateTime.now()));
    });
  }

  Future addGoal() async {
    String goalName = _goalNameController.text;
    List<Map<String, dynamic>> plansData =
        plans.map((plan) => plan.toMap()).toList();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.docID) // Replace with actual doc ID
        .collection('goals')
        .add({
      'goalName': goalName,
      'plans': plansData,
    });
  }

  @override
  Widget _buildTextField(TextEditingController controller, String hintText,
      {Function(String)? onChanged}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
          fillColor: Color.fromARGB(255, 47, 46, 46),
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color.fromARGB(255, 31, 30, 30)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget _buildDateField(PlanDetails plan) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: TextFormField(
        decoration: InputDecoration(
          icon: Icon(Icons.calendar_today,
              color: Color.fromARGB(255, 178, 173, 173)),
          hintText: "When to End",
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        readOnly: true,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        initialValue: plan.whenToEnd != null
            ? DateFormat('yyyy-MM-dd').format(plan.whenToEnd)
            : '',
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: plan.whenToEnd,
            firstDate: DateTime(1960),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              plan.whenToEnd = pickedDate;
            });
          }
        },
      ),
    );
  }

  @override
  Widget _buildNumberPicker(PlanDetails plan) {
    int tempMintimes = plan.mintimes; // 临时变量用于存储滚轮选择的值

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 28.0, top: 8.0, bottom: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Minimum Completion Times',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 100, // 调整滚轮高度
                padding: EdgeInsets.symmetric(horizontal: 28.0), // 添加左边距
                child: CupertinoPicker(
                  itemExtent: 32.0,
                  backgroundColor: Colors.transparent,
                  onSelectedItemChanged: (int selectedIndex) {
                    tempMintimes = selectedIndex; // 更新临时变量
                  },
                  children: List<Widget>.generate(100, (index) {
                    return Center(
                      child: Text(
                        index.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }),
                  scrollController:
                      FixedExtentScrollController(initialItem: plan.mintimes),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.check, color: Colors.green),
              onPressed: () {
                setState(() {
                  plan.mintimes = tempMintimes; // 确认选择，更新 plan 对象
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget _buildPlanCard(PlanDetails plan) {
    TextEditingController planContextController =
        TextEditingController(text: plan.planContext);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Card(
        margin: EdgeInsets.all(8.0),
        color: Colors.indigo[100],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 15.0),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      planContextController,
                      'Plan Context',
                      onChanged: (value) => plan.planContext = value,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete,
                        color: const Color.fromARGB(255, 103, 100, 100)),
                    onPressed: () {
                      setState(() {
                        plans.remove(plan);
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              _buildDateField(plan),
              SizedBox(
                height: 10.0,
              ),
              _buildNumberPicker(plan),
              SizedBox(
                height: 10.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: Text(
          'Set Sleep Goal',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 158, 49, 178),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bed_outlined,
                  size: 80,
                  color: Color.fromARGB(255, 197, 206, 201),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: _goalNameController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Goal Name',
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      fillColor: Color.fromARGB(255, 47, 46, 46),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 31, 30, 30))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                for (var plan in plans) ...[
                  _buildPlanCard(plan),
                ],
                ElevatedButton(
                  onPressed: addPlan,
                  child: Icon(Icons.add),
                ),
                ElevatedButton(
                  onPressed: addGoal,
                  child: Text('Save Goal'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
