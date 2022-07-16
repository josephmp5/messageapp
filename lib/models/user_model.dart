import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  String phoneNumber;
  Timestamp date;
  String uid;
  String image;

  UserModel({
    required this.phoneNumber,
    required this.date,
    required this.uid,
    required this.image,
  });

  //auth controllerda image'ın linkini ve kullanıcının adını düzgün bi şekilde düzeltmen lazım

  

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    return UserModel(phoneNumber: snapshot['phoneNumber'], date: snapshot['date'], uid: snapshot['uid'], image: snapshot['image']);
  }

}