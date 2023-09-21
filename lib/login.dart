import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final _formfield = GlobalKey<FormState>();
  final usercontroller = TextEditingController();
  final passcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
            children: [
              SizedBox(height: 80,),
              Center(
                child: Container(
                  height: 300,
                  width: 300,
                  child: Form(
                    key: _formfield,
                    child: Column(
                      children: [
                        Container(
                            height: 50,
                            width: 200,
                            child: ElevatedButton(onPressed: (){
                              if(usercontroller.text.isNotEmpty && passcontroller.text.length>6){
                                signup();
                              }
                              else {
                                debugPrint('LOG: Username and password not valid');
                              }
                            }, child: Text("Sign Up",
                              style: TextStyle(color: Colors.white),),

                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue[700]),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: usercontroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Username';
                              }
                              final uservalid = RegExp(r"^[a-zA-Z0-9_]").hasMatch(value);
                              if (!uservalid) {
                                return "Enter Valid Username";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Username",
                              prefixIcon: Icon(Icons.person),
                              border: OutlineInputBorder(

                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: passcontroller,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter Password';
                              }
                              final uservalid = RegExp(
                                  r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$").hasMatch(value);
                              if (!uservalid) {
                                return "Enter Valid Password";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Enter Password",
                              prefixIcon: Icon(Icons.password),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: (){
                            if(_formfield.currentState!.validate()){
                              login();
                            }
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>Bottom()));

                          }, child: Text("Login",style: TextStyle(color: Colors.black),)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
  Future<UserCredential>login()async{
    final _auth =FirebaseAuth.instance;
   try{
     UserCredential usercredintial=
     await _auth.signInWithEmailAndPassword(email: usercontroller.text, password: passcontroller.text);
     _firestore.collection('users').doc(usercredintial.user!.uid).set({
       'uid':usercredintial.user!.uid,
       'email': usercontroller.text,
     });
     return usercredintial;
   }on FirebaseAuthException catch(e){
     throw Exception(e.code);
   }
  }
  Future<UserCredential>signup()async{
    final auth =FirebaseAuth.instance;
    try{
      UserCredential usercredintial=
      await auth.createUserWithEmailAndPassword(email: usercontroller.text, password: passcontroller.text);
      _firestore.collection('users').doc(usercredintial.user!.uid).set({
        'uid':usercredintial.user!.uid,
        'email': usercontroller.text,
      },SetOptions(merge: true));
      return usercredintial;
    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }
}
