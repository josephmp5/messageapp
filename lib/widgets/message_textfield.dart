import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class MessageTextField extends StatefulWidget {

 
  final String currentId;
  final String userId;


  MessageTextField({
    required this.currentId,
    required this.userId,
  });

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


   File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection('users').doc(widget.currentId).collection('messages').doc(widget.userId).collection('chats')
        .doc(fileName)
        .set({
      "senderId":widget.currentId,
      "receiverId":widget.userId,
      "message": "",
      "type": "img",
      "date":DateTime.now(),
    });

    await _firestore
        .collection('users').doc(widget.userId).collection('messages').doc(widget.currentId).collection('chats')
        .doc(fileName)
        .set({
      "senderId":widget.currentId,
      "receiverId":widget.userId,
      "message": "",
      "type": "img",
      "date":DateTime.now(),
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('users').doc(widget.currentId).collection('messages').doc(widget.userId).collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('users').doc(widget.currentId).collection('messages').doc(widget.userId).collection('chats')
          .doc(fileName)
          .update({"message": imageUrl}).then((value) {
              FirebaseFirestore.instance.collection('users').doc(widget.currentId).collection('messages').doc(widget.userId).set({
                'last_msg':imageUrl,
              });
            });

      await _firestore
          .collection('users').doc(widget.userId).collection('messages').doc(widget.currentId).collection('chats')
          .doc(fileName)
          .update({"message": imageUrl}).then((value) {
              FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('messages').doc(widget.currentId).set({
                'last_msg':imageUrl,
              });
            });      

      print(imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsetsDirectional.all(8),
      child: Row(
        children: [
          Expanded(child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "Type your message",
              fillColor: Colors.grey[100],
              filled: true,
              suffixIcon: IconButton(onPressed: getImage, icon: Icon(Icons.photo)),
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 0),
                gapPadding: 10,
                borderRadius: BorderRadius.circular(25)
              )
            ),
          )),

          SizedBox(width: 20,),
          GestureDetector(
            onTap: ()async{

              String message = _controller.text;
              _controller.clear();
              await FirebaseFirestore.instance.collection('users').doc(widget.currentId).collection('messages').doc(widget.userId).collection('chats').add({
                "senderId":widget.currentId,
                "receiverId":widget.userId,
                "message":message,
                "type":"text",
                "date":DateTime.now(),
            }).then((value) {
              FirebaseFirestore.instance.collection('users').doc(widget.currentId).collection('messages').doc(widget.userId).set({
                'last_msg':message,
              });
            });

            await FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('messages').doc(widget.currentId).collection("chats").add({
               "senderId":widget.currentId,
               "receiverId":widget.userId,
               "message":message,
               "type":"text",
               "date":DateTime.now(),

            }).then((value) {
              FirebaseFirestore.instance.collection('users').doc(widget.userId).collection('messages').doc(widget.currentId).set({
                "last_msg":message
              });
            });

            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue
              ),
              child: Icon(Icons.send,color: Colors.white,),
            ),
          )

        ],
      ),
      
    );
  }
}