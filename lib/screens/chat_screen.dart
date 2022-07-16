import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/widgets/message_textfield.dart';
import 'package:chatapp/widgets/single_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {


  const ChatScreen({ Key? key,required this.currentUser,required this.userId,required this.phoneNumber,required this.userImg}) : super(key: key);

  final UserModel currentUser;
  final String userId;
  final String phoneNumber;
  final String userImg;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Row(
          children: [
             ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child:  CachedNetworkImage(
                            imageUrl:userImg,
                            placeholder: (conteext,url)=>CircularProgressIndicator(),
                            errorWidget: (context,url,error)=>Icon(Icons.error,),
                            height: 40,
                          ),
            ),
            SizedBox(width: 5,),
            Text(phoneNumber,style: TextStyle(fontSize: 20),)
          ],
        ),
      ),

      body: Column(
        children: [
          Expanded(child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25),),
            ),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").doc(currentUser.uid).collection("messages").doc(userId).collection("chats").orderBy("date",descending: true).snapshots(),
              builder: (context,AsyncSnapshot snapshot) {
                if(snapshot.hasData) {
                  if(snapshot.data.docs.length < 1) {
                     return Center(
                       child: Text("write something"),
                     ); 
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context,index) {
                      
                      bool isMe = snapshot.data.docs[index]['senderId'] == currentUser.uid;
                      return SignleMessage(message: snapshot.data.docs[index]['message'], isMe: isMe,map: snapshot.data.docs[index]['type'],);

                    });
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },),
          ),
        ),
        MessageTextField(currentId: currentUser.uid, userId: userId)
        ],
      ),
      
    );
  }
}