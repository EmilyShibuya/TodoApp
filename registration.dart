import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/main.dart';

class Registration extends StatelessWidget {
   Registration({Key? key}) : super(key: key);
  String? mailAddress;
  String? password;
  String? passwordCheck;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("新規登録"),
      ),
      body: Column(
        children: [
          CustomTextField(label: "メールアドレス", onChangedfunc: (newText){mailAddress = newText;},isPassword: false,),
          CustomTextField(label: "パスワード", onChangedfunc: (newText){password = newText;},isPassword: true,),
          CustomTextField(label: "パスワード確認", onChangedfunc: (newText){passwordCheck = newText;},isPassword: true,),
          ElevatedButton(
              onPressed: () async {
                if (passwordCheck!=password){
                  showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("エラー"),
                          content: Text("パスワードを正しく入力して下さい。"),
                        actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("OK"))],);});
                }
                else{
                  if ( mailAddress != null && password != null) {
                    try {
                      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: mailAddress!,
                          password: password!
                      );

                      showDialog(context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("登録しました"),
                            content: Text("登録完了しました。"),
                            actions: [TextButton(onPressed: (){Navigator.popUntil(context, (route) => route.isFirst);}, child: Text("OK"))],);
                        }
                      );
                     // Navigator.push(MaterialPage(context)=>Text("OK");)
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        showDialog(context: context, builder: (context){return AlertDialog(
                          title: Text("エラー"),
                          content: Text("パスワードが短すぎます。"),
                          actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("OK"))],);});
                      } else if (e.code == 'email-already-in-use') {
                        showDialog(context: context, builder: (context){return AlertDialog(
                          title: Text("エラー"),
                          content: Text("パスワードが短すぎます。"),
                          actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("OK"))],);});
                      }
                    } catch (e) {
                      showDialog(context: context, builder: (context){return AlertDialog(
                        title: Text("エラー"),
                        content: Text(e.toString()),
                        actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("OK"))],);});

                    }
                  }else
                    {
                      showDialog(context: context, builder: (context){return AlertDialog(
                        title: Text("エラー"),
                        content: Text("未入力項目があります。"),
                        actions: [TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("OK"))],);});

                    }
                }
              },
              child: Container(
                  width: 200,
                  height: 50,
                  alignment: Alignment.center,
                  child: Text('新規登録', textAlign: TextAlign.center,)))
        ],
      ),
    );
  }
}
