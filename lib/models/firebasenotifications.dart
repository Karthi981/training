import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;


  Future<void> initNotifications() async {
    final fcmtoken = _firebaseMessaging.getToken();
    print('Token: $fcmtoken');
  }

  Future<void> setupToken() async {
    // Get the token each time the application loads

    await _firebaseMessaging.requestPermission();
    String? token1 = await FirebaseMessaging.instance.getToken();
    print('Token: $token1');
     FirebaseAuth.instance.authStateChanges().listen((firebaseUser) {
       if(firebaseUser != null){
       createtoken(token1!);
       print(firebaseUser);
       }else{
       print("Please Login");
       print(firebaseUser);
       }
    });

  }
  //
  Future<void> createtoken(String token2) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'token': token2});
    print("created token");
  }
}
