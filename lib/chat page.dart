import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:training/chatservice/chat.dart';
import 'package:training/components/chatbubble.dart';
import 'package:http/http.dart' as http;

class Chatpage extends StatefulWidget {
  final String receiveruseremail;
  final String receiverUserId;
  final String token;
  const Chatpage({super.key,required this.receiveruseremail,required this.receiverUserId,
  required this.token});

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {


  final ChatService _chatService =ChatService();
  TextEditingController sendMessagecontoller = TextEditingController();
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  String? accesstoken;



  void sendFcm(String title, String body, String fcmToken) async {
    getaccesstoken();
    final String postUrl = 'https://fcm.googleapis.com/v1/projects/training-147f7/messages:send';
    final data = {
      "message":{
        "token":fcmToken,
        "notification":{
          "body":body,
          "title":title,
        }
      }
    };
   final  headers ={
      'content-type':'application/json',
      'Authorization': 'Bearer ya29.a0AfB_byBfhPt5QND5_cpKBZJ_tcKZV_stvz_N2QZkptVEQbZgo0ECrlUPMcVyEOHa-Fnz0doo41DVCS-Ji6pYJ3_MlMEpYCFln-BiyCBbDmMkzA7UvBoVMMg2YrLwjzAbdz2uH2EGnajvEdtO84NLKIpBNmo6FLJPvzrMaCgYKATgSARASFQGOcNnC3TnWXdnKdjwD0x7LLVop2g0171'
    };
    final response = await http.post(Uri.parse(postUrl),
    body: jsonEncode(data),
    headers: headers,
    );
    if(response.statusCode == 200){
      print("Test Ok");
    }else{
      print("FCM Error");
    }
  }
  getaccesstoken()async{
    String collection = 'accesstoken';
    String documentId = 'Acess_token';
    String fieldToRetrieve = 'accesstoken'; // Replace with the field name you want to retrieve

    try {
      // Get the document snapshot
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection(collection)
          .doc(documentId)
          .get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Retrieve the specific field
         accesstoken = documentSnapshot[fieldToRetrieve];
        print('Field Value: $accesstoken');
      }
    }catch (e) {
      print('Error retrieving document: $e');
    }
  }
  void sendMessage()async{
    if(sendMessagecontoller.text.isNotEmpty){
      await _chatService.sendMessage(widget.receiverUserId,sendMessagecontoller.text );
      sendMessagecontoller.clear();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        centerTitle: true,
        title: Text(widget.receiveruseremail),
      ),
      body:
      Column(
        children: [
          Expanded(
              child:_buildMessageList() ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 300,
                  child: TextFormField(
                    controller: sendMessagecontoller,
                    decoration: InputDecoration(
                      label: Text('Enter the Message'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  sendMessage();
                  sendFcm(_firebaseAuth.currentUser!.email!, sendMessagecontoller.text, widget.token);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                      image: DecorationImage(
                          image: NetworkImage("https://cdn-icons-png.flaticon.com/512/2343/2343805.png")),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildMessageList(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
          stream: _chatService.getMessages(widget.receiverUserId,
          _firebaseAuth.currentUser!.uid),
          builder: (context, snapshot){
            if(snapshot.hasError){
              return Text('Error'+snapshot.error.toString());
            }
            else if(snapshot.connectionState==ConnectionState.waiting){
              return Center(child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text("Please Wait..."),
                ],
              ));
            }
            return ListView(
              children: snapshot.data!.docs.map((document) => _buildMessageitem(document)).toList(),
            );
          }),
    );
  }
  Widget _buildMessageitem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data() as Map<String,dynamic>;
    var alignment =
    (data['senderId'] ==_firebaseAuth.currentUser!.uid) ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: (data['senderId'] ==_firebaseAuth.currentUser!.uid)?
        CrossAxisAlignment.end:CrossAxisAlignment.start ,
        mainAxisAlignment: (data['senderId'] ==_firebaseAuth.currentUser!.uid)?
        MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(data['senderEmail'].toString()),
          ),
          Chatbubble(message: data['message'].toString()),
        ],
      ),
    );
  }
}
