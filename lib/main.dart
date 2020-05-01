import 'package:flutter/material.dart';
import 'package:todo/show.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Center(
            child: Text('TO DO'),
          ),
        ),
        body: TO(),
      ),
    );
  }
}

class TO extends StatefulWidget {
  @override
  _TOState createState() => _TOState();
}

class _TOState extends State<TO> {
  String task = '';
  List<Widget> notes = [];
  final nameHolder = TextEditingController();
  final _firestone = Firestore.instance;
  int i = 2;

  void get() async {
    final messages = await _firestone.collection(('todolist')).getDocuments();
    for (var message in messages.documents) {
      print(message.data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: 30.0),
          width: 350.0,
          child: TextField(
            controller: nameHolder,
            decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                icon: Icon(
                  Icons.note,
                )),
            onChanged: (value) {
              print(value);
              task = value;
            },
          ),
        ),
        FlatButton(
          onPressed: () {
            get();
            setState(() {
              _firestone.collection('todolist').add({'text': task});
              i++;
              notes.add(Show(
                value: task,
              ));
              nameHolder.clear();
            });
          },
          child: Text(
            'ADD',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        StreamBuilder<QuerySnapshot>(
            stream: _firestone.collection('todolist').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final lists = snapshot.data.documents.reversed;
                List<Widget> listwidget = [];
                for (var list in lists) {
                  final text = list.data['text'];
                  final id = list.documentID;
                  print('------------------>$id');
                  final lw = Dismissible(
                    child: ListTile(
                      title: Text(
                        '$text',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (direction) {
                      print('dimissed');
                      Firestore.instance
                          .collection('todolist')
                          .document(id)
                          .delete();
                    },
                    key: ValueKey(text),
                  );
                  listwidget.add(lw);
                }
                return Expanded(
                  child: ListView(
                    children: listwidget,
                  ),
                );
              }
            })
      ],
    );
  }
}

////Expanded(
////child: SingleChildScrollView(
////child: Column(
////children: notes,
////),
////),
//),
