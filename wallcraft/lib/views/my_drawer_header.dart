import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyHeaderDrawer extends StatefulWidget {
  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();

  String email = FirebaseAuth.instance.currentUser?.email as String;
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {

  @override
  void initState() {
    // TODO: implement
    super.initState();
    print(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: double.infinity,
      height: 300,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/profile.jpg'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              'Hello',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              widget.email,
              style: TextStyle(
                color: Colors.grey[200],
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}