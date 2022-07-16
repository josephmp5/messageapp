import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/main.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/navigation.dart';
import 'package:chatapp/screens/auth_screen.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/search_screen.dart';
import 'package:chatapp/screens/settingspage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


class HomeScreen extends StatefulWidget {

  UserModel user;
  HomeScreen(this.user);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
        actions: [
          IconButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: ((context) =>  SettingsPage())));}, icon: Icon(Icons.settings)),
        ],
      ),

     

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').doc(widget.user.uid).collection('messages').snapshots(),

        builder: (context,AsyncSnapshot snapshot) {
          if(snapshot.hasData) {
            if(snapshot.data.docs.length < 1) {
              return Center(
                child: Text("no chats available"),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index) {
                var userId = snapshot.data.docs[index].id;
                var lastMsg = snapshot.data.docs[index]['last_msg'];
                return FutureBuilder(
                  future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                  builder: (context, AsyncSnapshot asyncSnapshot) {
                    if(asyncSnapshot.hasData) {
                      var user = asyncSnapshot.data;
                      return ListTile(
                       leading: ClipRRect(
                          borderRadius: BorderRadius.circular(80),
                          child: CachedNetworkImage(
                            imageUrl:user['image'],
                            placeholder: (conteext,url)=>CircularProgressIndicator(),
                            errorWidget: (context,url,error)=>Icon(Icons.error,),
                            height: 50,
                          ),
                        ),
                        title: Text(user['phoneNumber']),
                        subtitle: Container(
                          child: Text("$lastMsg",style: TextStyle(color: Colors.grey),overflow: TextOverflow.ellipsis,),
                        ),
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(
                            currentUser: widget.user, userId: user['uid'], phoneNumber: user['phoneNumber'],userImg: user['image'],)));
                        },
                      );
                    }

                    return LinearProgressIndicator();
                  },
                );
              });
          } 
          return Center(
            child: CircularProgressIndicator(),
          );
        }),


      
        
       floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => SearchScreen(user: widget.user)));
        },
      ),  

      

      
    
      
    );
  }
}