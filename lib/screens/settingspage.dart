import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatapp/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key,}) : super(key: key);

  
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  

  File? myImage;

  final user = FirebaseAuth.instance.currentUser;

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    
    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL(); 

    final appUser = FirebaseFirestore.instance.collection('users').doc(user!.uid);

    appUser.update({'image': urlDownload});


    
  }

  Future selectFile() async {


    final result =
        await FilePicker.platform.pickFiles();

        if(result == null) return;

        setState(() {
          pickedFile = result.files.first;
        });


  }

  @override
  Widget build(BuildContext context) {   

    final user = FirebaseAuth.instance.currentUser;

     
    return Scaffold(

      appBar: AppBar( 
        title: const Text('Settings Page'),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,),

       body:  StreamBuilder(
         stream: FirebaseFirestore.instance.collection('users').where('uid', isEqualTo: user!.uid).snapshots(),
         builder: (context,AsyncSnapshot snapshot) {
           if(snapshot.hasData) {
             if(snapshot.data.docs.length > 0) {
               var snap = snapshot.data;
               return ListView.builder(
                 itemCount: snapshot.data.docs.length,
                 itemBuilder: (context,index) {
                   var snap = snapshot.data.docs[index];
                    return Column(
                      children: [
                        ListTile(
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(150),
                              child: CachedNetworkImage(
                                imageUrl:snap['image'],
                                placeholder: (conteext,url)=>CircularProgressIndicator(),
                                errorWidget: (context,url,error)=>Icon(Icons.error,),
                                height: 150,
                              ),
                            ),

                        ),

                        ElevatedButton(onPressed: selectFile, child: Text("select file")),
                        ElevatedButton(onPressed: uploadFile, child: Text("upload file")),
                      ],
                    );
                 });
             }
           } return Center(child: CircularProgressIndicator(),);
         },
       ),

       

        

    );
    
  }

  
}