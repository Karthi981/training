import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:training/chat%20page.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings('app_icon'), // Adjust as needed
    );
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Handle foreground messages here
      displayNotification(message);
    });
  }

  Future<void> onSelectNotification(String? payload) async {
    // Handle notification tap
  }

  Future<void> displayNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id', 'Your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      message.notification?.title ?? '',
      message.notification?.body ?? '',
      platformChannelSpecifics,
      payload: message.data['your_data_key'],
    );
  }


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
