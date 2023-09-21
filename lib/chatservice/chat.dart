import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:training/chatservice/message.dart';

class ChatService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void>sendMessage(String receiverId,String message)async {
    //get current user info
    final String currentuserId = _firebaseAuth.currentUser!.uid;
    final String currentuserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();
    //create a new message
    Message newMessage = Message(
        senderId: currentuserId,
        senderEmail: currentuserEmail,
        receiverId: receiverId,
        message: message,
        timestamp: timestamp);
    //construct chatroom-id
    List<String> ids = [receiverId,currentuserId];
    ids.sort();
    print(ids);
    String chatRoomId = ids.join("_");
    //add new message to database
    await _firestore.collection("chat_rooms").doc(chatRoomId).collection(
        'messages').add(newMessage.toMap());
  }
    //getMessages
    Stream<QuerySnapshot> getMessages(String userId, String otheruserId){
      List<String> ids = [userId, otheruserId];
      ids.sort();
      print(ids);
      String chatRoomId = ids.join("_");
      return _firestore.collection("chat_rooms").doc(chatRoomId).collection('messages').orderBy(
        'timestamp',descending: false
      ).snapshots();

  }
  Stream<DocumentSnapshot<Map<String, dynamic>>>getaccesstoken(){
    return _firestore.collection("accesstoken").doc("Acess_token").snapshots();
  }
}