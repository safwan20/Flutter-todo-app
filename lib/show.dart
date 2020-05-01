import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Show extends StatelessWidget {
  Show({this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      child: ListTile(
        title: Text(
          value,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
      key: ValueKey(value),
    );
  }
}
