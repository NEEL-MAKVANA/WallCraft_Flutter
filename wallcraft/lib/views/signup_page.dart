import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallcraft/controller/auth_controller.dart';
import 'package:wallcraft/views/login_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    // var userController = TextEditingController();

    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('SignUp'),
          centerTitle: true,
          // centerTitle: true,
          // automaticallyImplyLeading: false,
          // actions: <Widget>[
          //   IconButton(
          //     icon: const Icon(Icons.arrow_back),
          //     tooltip: 'Login',
          //     onPressed: () {
          //       Navigator.pop(context);
          //     },
          //   ),
          // ],
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
                height: h * 0.40,
                margin: EdgeInsets.only(top: 30),
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/newsignup.png"),
                  fit: BoxFit.cover,
                )),
              ),
              Container(
                width: w,
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        "Register your account",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // const Text(
                    //   "Register your account",
                    //   style: TextStyle(fontSize: 20, color: Colors.grey),
                    // ),
                    // const SizedBox(height: 25),
                    // Container(
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(30),
                    //       boxShadow: [
                    //         BoxShadow(
                    //             blurRadius: 10,
                    //             spreadRadius: 7,
                    //             offset: const Offset(1, 1),
                    //             color: Colors.grey.withOpacity(0.2))
                    //       ]),
                    //   child: TextField(
                    //     controller: userController,
                    //     decoration: InputDecoration(
                    //         hintText: "Username",
                    //         prefixIcon: const Icon(
                    //           Icons.supervised_user_circle,
                    //           color: Colors.deepPurple,
                    //         ),
                    //         focusedBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(30),
                    //             borderSide: const BorderSide(
                    //                 color: Colors.white, width: 1.0)),
                    //         enabledBorder: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(30),
                    //             borderSide: const BorderSide(
                    //                 color: Colors.white, width: 1.0)),
                    //         border: OutlineInputBorder(
                    //             borderRadius: BorderRadius.circular(30))),
                    //   ),
                    // ),
                    const SizedBox(height: 30),
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
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 10,
                                spreadRadius: 7,
                                offset: const Offset(1, 1),
                                color: Colors.grey.withOpacity(0.2))
                          ]),
                      child: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: const Icon(
                              Icons.password_rounded,
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
                    // const SizedBox(height: 15),
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Container(),
                    //     ),
                    //     const Text(
                    //       "forgot your password?",
                    //       style: TextStyle(fontSize: 20, color: Colors.grey),
                    //     ),
                    //   ],
                    // )
                  ],
                ),
              ),
              SizedBox(
                height: w * 0.1,
              ),
              GestureDetector(
                onTap: () {
                  AuthController.instance.register(emailController.text.trim(),
                      passwordController.text.trim());
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
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: w * 0.05,
              ),
              // RichText(
              //     text: TextSpan(
              //         recognizer: TapGestureRecognizer()
              //           ..onTap = () => Get.back(),
              //         text: "Already Have an account?",
              //
              //
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //           fontSize: 20,
              //           color: Colors.black,
              //         )),
              //
              // )

              RichText(
                  text: TextSpan(
                      text: "Already Have an Account?",
                      style: TextStyle(color: Colors.grey[500], fontSize: 20),
                      children: [
                    TextSpan(
                        text: " Login",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                )
                              })
                  ])),

              // SizedBox(
              //   height: w * 0.06,
              // ),
              // RichText(
              //     text: TextSpan(
              //         text: "Don\'t have an account?",
              //         style: TextStyle(color: Colors.grey[500], fontSize: 20),
              //         ))
            ],
          ),
        ));
  }
}
