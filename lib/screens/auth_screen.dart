import 'dart:io';
import 'package:chatapp/utils/auth_controller.dart';
import 'package:chatapp/utils/showsnackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chatapp/custom_button.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:chatapp/models/user_model.dart' as model;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
 
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    phoneController.dispose();
  }

  void phoneSignIn() async{

    QuerySnapshot query = await FirebaseFirestore.instance.collection('users').where('phoneNumber',isEqualTo:'+90' + phoneController.text).get();
      if (query.docs.length==0){

        authController(FirebaseAuth.instance).phoneSignIn(context, phoneController.text);
         
    }
    else {
         showSnackBar(context, "there is same number under another account");
   //Go to the login screen
      } 
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         
            Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                
                image: DecorationImage(image: AssetImage("assets/image/6.png"),
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
                
                
                ),
                shape: BoxShape.circle
              ),
                
             
              
            ),
            const SizedBox(height: 30),
            const Text(
              'FVCK MARK',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,color: Colors.pinkAccent),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  TextFormField(
                    maxLength: 10,
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      icon: Icon(Icons.phone,color: Colors.deepPurpleAccent,),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.deepPurpleAccent),
                        ),
                        prefix: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '+90',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                       ),
                  ),
                ],
              ),
            ),  

            SizedBox(height: 15,),

            CustomButton(onTap: phoneSignIn, text:"SIGN UP")     
        ],
            
      ), 
    );
  }
}