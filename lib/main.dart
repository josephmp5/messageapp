import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/screens/auth_screen.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<Widget> userSignedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null) {

      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      UserModel userModel = UserModel.fromJson(userData);

      return HomeScreen(userModel);

    }else {
      return AuthScreen();
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        
        future: userSignedIn(),
        builder: (context,AsyncSnapshot<Widget> snapshot) {

        if(snapshot.hasData) {
          return snapshot.data!;
        }

        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );

      }),
    );
  }
}


