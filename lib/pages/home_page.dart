import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:keeping_fit/read%20data/get_user_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  // String docID = "";
  // Map<String, dynamic> userData

  // Future getDocId() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(user.email)
  //       .get()
  //       .then((doc) {

  //       })
  //       ;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 178, 173, 173),
        title: Text(
          'HOME',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Icon(Icons.logout),
            ),
          )
        ],
      ),
      body: GetUserData(docID: user.email!),
    );
  }
}