import 'package:flutter/material.dart';

class SignleMessage extends StatelessWidget {
 
 final String? message;
 final bool isMe;
 final String map;

 SignleMessage({
   required this.message,
   required this.isMe,
   required this.map
 });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return map == "text" 
    ? Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
            color: isMe ? Colors.black : Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: Text(message!,style: TextStyle(color: Colors.white),),
        ),
      ],
      
    )
    :Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          height: size.height / 2.5,
                width: size.width / 2,
                decoration: BoxDecoration(border: Border.all()),
          constraints: BoxConstraints(maxWidth: 200),
          child: message != ""
                    ? Image.network(
                        message!,
                        fit: BoxFit.cover,
                      )
                    : CircularProgressIndicator(),
              
        ),
      ],
      
    );
  }
}