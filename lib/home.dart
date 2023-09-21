import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:training/chat%20page.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: (){
            FirebaseAuth.instance.signOut();
        },
                icon: Icon(Icons.logout)),
          )],
        backgroundColor: Colors.red,
        title: Text("Push Notifications"),
      ),
      body: _builduserlist(),

    );
  }
  Widget _builduserlist(){
    return StreamBuilder<QuerySnapshot>(
        stream:FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return const Text("Error");
          }
          else if(snapshot.connectionState==ConnectionState.waiting){
            return CircularProgressIndicator();
          }
          return ListView(
            children:snapshot.data!.docs.map<Widget>((doc) =>_builduserlistItem(doc)).toList(),
          );
        });
  }
  Widget _builduserlistItem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data()! as Map<String,dynamic>;
    if(_auth.currentUser!.email != data['email']){
      return ListTile(
        title: Text(data['email'].toString()),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Chatpage(
            receiveruseremail:data['email'] ,
            receiverUserId: data['uid'],
            token: data['token'],
          )));
        },
      );
    }
   else{
     return Container();
    }
  }
}
