import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ThreeSection extends StatefulWidget {
  final String docID;
  const ThreeSection({super.key, required this.docID});

  @override
  State<ThreeSection> createState() => _ThreeSectionState();
}

class _ThreeSectionState extends State<ThreeSection> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
