import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Todo extends StatelessWidget {
  User user;
  Todo({required this.user, Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(user.uid).snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Todo"),
              automaticallyImplyLeading: false,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: (){
                showDialog(context: context, builder: (BuildContext context ){
                  String? newItem;
                  return SimpleDialog(
                    title: TextField(
                      onChanged: (newText){
                        newItem = newText;
                      },
                    ),
                    children: [TextButton(onPressed: (){if(newItem!=null) {
                      FirebaseFirestore.instance.collection(user.uid).doc(
                          '${snapshot.data!.docs.length}').set({
                        'item': newItem,
                        'done': false
                      });
                      Navigator.pop(context);
                    }
                    }, child: Text('OK'))],
                  );
                });
              },
              child: Icon(Icons.add)
            ),
            body: snapshot.hasData ? ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  onLongPress: (){FirebaseFirestore.instance.collection(user.uid).doc('${index}').delete();},
                  onTap: (){FirebaseFirestore.instance.collection(user.uid).doc('${index}').set({
                    'item': snapshot.data!.docs[index]['item'],
                    'done': !snapshot.data!.docs[index]['done']
                  });},
                  title: Text(snapshot.data!.docs[index]['item']),
                  trailing:  (snapshot.data!.docs[index]['done'] == true) ? Icon(Icons.check) : null,
                );

              }): Center(child: CircularProgressIndicator()),

          );
        });
  }
}
