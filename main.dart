import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo/registration.dart';
import 'package:todo/todo.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {

  String? mailAddress = "flutter.database.jp@gmail.com";
  String? password = "password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ログイン画面"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text("ToDoアプリ", style: TextStyle(fontSize: 50),),
                Text("ログインして下さい。"),
              ],
            ),
          ),
          CustomTextField(label: "メールアドレス", onChangedfunc: (newText){mailAddress = newText;},isPassword: false,),
          CustomTextField(label: "パスワード", onChangedfunc: (newText){password = newText;},isPassword: true,),
          Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("新規登録は"), TextButton(onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Registration()));
              },child: Text("こちら"),)]),
          ElevatedButton(
              onPressed: () async {
                try {
                  UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: mailAddress!,
                      password: password!
                  );

print(userCredential.user!);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Todo(user: userCredential.user!,)));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'user-not-found') {
                    showDialog(context: context, builder: (context){return AlertDialog(
                      title: Text("エラー"),
                      content: Text("メールアドレスが見つかりません。"),
                      actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("OK"))],);});
                  } else if (e.code == 'wrong-password') {
                    showDialog(context: context, builder: (context){return AlertDialog(
                      title: Text("エラー"),
                      content: Text("パスワードが違います。"),
                      actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("OK"))],);});
                  }
                }
              },
              child: Container(
                  width: 200,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text('ログイン', textAlign: TextAlign.center,)))
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  String label;
  void Function(String text) onChangedfunc;
  bool isPassword;
  
  CustomTextField({
    required this.label,
    required this.onChangedfunc,
    required this.isPassword,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onChanged: (newText){
          onChangedfunc(newText);
        },
        obscureText: isPassword? true : false,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))
          )
        ),
      ),
    );
  }
}
