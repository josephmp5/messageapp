import 'package:chatapp/main.dart';
import 'package:chatapp/utils/showOTPDialog.dart';
import 'package:chatapp/utils/showsnackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';


class authController {

final FirebaseAuth _auth;
authController(this._auth);


  Future<void> phoneSignIn(BuildContext context,String phoneNumber,) async{

    TextEditingController codeController = TextEditingController();

    await _auth.verifyPhoneNumber(phoneNumber: phoneNumber, 
    verificationCompleted: (PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    }, 
    verificationFailed: (e) {

      showSnackBar(context, e.message!);
      
    }, 
    codeSent:((String verificationId, int? resendToken) async {

      showOTPDialog(context: context, codeController: codeController, onPressed: () async {

        PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: codeController.text.trim(),);


        UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

        await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
        'phoneNumber':userCredential.user!.phoneNumber,
        'uid':userCredential.user!.uid,
        'date':DateTime.now(),
        'image': 'https://firebasestorage.googleapis.com/v0/b/messageapp-134e5.appspot.com/o/png-clipart-computer-icons-user-profile-avatar-profile-heroes-profile.png?alt=media&token=cd978701-eec3-43ae-a840-382b0b12917b',
         //burası daha bitmedi halletmen gerekiyor tüm kullanıclar user olamaz aga

        });


        Navigator.of(context).pop();

        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
       

      });

     

      
    }), 
    codeAutoRetrievalTimeout: (String verificationId) {

    });

    

    

  }


}