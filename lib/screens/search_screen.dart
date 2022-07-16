import 'package:chatapp/models/user_model.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  UserModel user;
  SearchScreen({required this.user});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;

  void onSearch() async {
    setState(() {
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance.collection('users').where("phoneNumber",isEqualTo: searchController.text).get().then((value) {
      if(value.docs.length < 1) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No result")));
        setState(() {
          isLoading = false;
        });
        return;
      }
      value.docs.forEach((user) {
        if(user.data()['phoneNumber'] != widget.user.phoneNumber) {
          searchResult.add(user.data());
        }
       
       });
    setState(() {
          isLoading = false;
        });

    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search users"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "type username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)
                      )
                    ),
                  ),
                ),
              ),
              IconButton(onPressed: (){
                onSearch();
              }, icon: Icon(Icons.search))
            ],
          ),

         if(searchResult.length > 0)
         Expanded(child: ListView.builder(
           itemCount: searchResult.length,
           shrinkWrap: true,
           itemBuilder: (context,index) {
             return ListTile(
               leading: CircleAvatar(
                      child: Image.network(searchResult[index]['image']),
                    ),
               title: Text(searchResult[index]['uid']),
               subtitle: Text(searchResult[index]['phoneNumber']),
               trailing: IconButton(onPressed: (){
                 setState(() {
                   searchController.text = "";
                 });

                 Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(currentUser: widget.user, userId: searchResult[index]['uid'], phoneNumber: searchResult[index]['phoneNumber'],userImg: searchResult[index]['image'],)));
               }, icon: Icon(Icons.message)),
             );
           }))
         else if(isLoading == true)
         Center(child: CircularProgressIndicator(),)
        ],
      ),
      
    );
  }
}