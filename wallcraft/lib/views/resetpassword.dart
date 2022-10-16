import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../controller/auth_controller.dart';

class ResetPass extends StatefulWidget {
  const ResetPass({Key? key}) : super(key: key);

  @override
  State<ResetPass> createState() => _ResetPassState();
}

class _ResetPassState extends State<ResetPass> {
  var emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('ResetPassword'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue,
                  Colors.indigo,
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: w,
                height: h * 0.35,
                margin: EdgeInsets.only(top: 5),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/newlogin.png"),
                      fit: BoxFit.cover,
                    )),
              ),
              Container(
                width: w,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      "Enter Your Email",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 7,
                                offset: const Offset(1, 1),
                                color: Colors.grey.withOpacity(0.2))
                          ]),
                      child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: const Icon(
                              Icons.email,
                              color: Colors.blue,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                    color: Colors.white, width: 1.0)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30))),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          // boxShadow: [
                          //   BoxShadow(
                          //       blurRadius: 10,
                          //       spreadRadius: 7,
                          //       offset: const Offset(1, 1),
                          //       color: Colors.grey.withOpacity(0.2))
                          // ]
                      ),

                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(),
                        ),
                        // const Text(
                        //   "forgot your password?",
                        //   style: TextStyle(fontSize: 20, color: Colors.grey),
                        // ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                // onTap: () {
                //   AuthController.instance.resetPassword(email:emailController.text.trim());
                // },
                onTap: () async {
                  // AuthController.instance.resetPassword(email: emailController.text.trim());
                  // Navigator.of(context).pop();
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text.trim());
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.green.shade600,
                        action: SnackBarAction(
                          label: '',
                          onPressed: () {
                            // Code to execute.
                          },
                        ),
                        content: const Text(
                            'Password reset link has been sent to your email account.'),
                        duration: const Duration(
                            milliseconds: 2500),
                        // width: 280.0, // Width of the SnackBar.
                        // padding: const EdgeInsets.symmetric(
                        //   horizontal: 8.0, // Inner padding for SnackBar content.
                        // ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(20.0),
                        ),
                      ));

                },
                child: Container(
                  width: w * 0.5,
                  height: h * 0.07,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue,
                        Colors.indigo,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    //     image: DecorationImage(
                    //       image: AssetImage(
                    //           "img/login.png"
                    //       ),
                    //       fit: BoxFit.cover,
                    //     )
                  ),
                  child: const Center(
                    child: Text(
                      "Reset",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),


            ],
          ),
        ));
  }
}
