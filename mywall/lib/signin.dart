import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mywall/sizeFunctions.dart';
import 'package:mywall/wall.dart';
import 'package:shared_preferences/shared_preferences.dart';

class signin extends StatefulWidget {
  const signin({Key? key}) : super(key: key);

  @override
  _signinState createState() => _signinState();
}

class _signinState extends State<signin> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late String email;
  late String pass;

  Future<void> alreadyLoggedIn() async {
    final SharedPreferences prefs = await _prefs;

    String? gotEmail = prefs.getString('email');
    String? gotPass = prefs.getString('pass');

    if (gotEmail != null && gotPass != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
          email: gotEmail,
          password: gotPass,
        )
            .then((value) async {
          final SharedPreferences prefs = await _prefs;
          prefs.setString('uid', value.user!.uid.toString());
          prefs.setString('email', gotEmail);
          prefs.setString('pass', gotPass);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => wall(
                        uid: value.user!.uid.toString(),
                        email: value.user!.email.toString(),
                      )));
          return value;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    alreadyLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, //Color.fromRGBO(16, 29, 37, 1),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: heightProp(100),
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                    //color: Color.fromRGBO(12, 169, 150, 1),
                    color: Color.fromRGBO(157, 165, 172, 1),
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: heightProp(100),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      //color: Color.fromRGBO(12, 169, 150, 1),
                      color: Colors.white),
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.email,
                          //color: Color.fromRGBO(157, 165, 172, 1),
                        ),
                        hintText: 'Your email address?',
                        labelText: 'Email *',
                      ),
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: heightProp(50),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    //color: Color.fromRGBO(12, 169, 150, 1),
                    color: Colors.white,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.password
                            //color: Color.fromRGBO(157, 165, 172, 1),
                            ),
                        hintText: 'Password',
                        labelText: 'Password *',
                      ),
                      onChanged: (value) {
                        pass = value;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: heightProp(100),
                ),
                TextButton(
                  onPressed: () async {
                    print(email);
                    print(pass);
                    try {
                      UserCredential userCredential =
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                        email: email,
                        password: pass,
                      )
                              .then((value) async {
                        final SharedPreferences prefs = await _prefs;
                        prefs.setString('uid', value.user!.uid.toString());
                        prefs.setString('email', email);
                        prefs.setString('pass', pass);
                        // print(value);
                        // print('success');
                        //print(value.user!.displayName);
                        print(value.user!.email);
                        print(value);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => wall(
                                      uid: value.user!.uid.toString(),
                                      email: value.user!.email.toString(),
                                    )));
                        return value;
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    }
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => chatPage()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.pink, //Color.fromRGBO(12, 169, 150, 1),
                    ),
                    child: const Center(
                        child: Text(
                      'Click here to login',
                      style: TextStyle(color: Colors.black),
                    )),
                  ),
                ),
                SizedBox(
                  height: heightProp(20),
                ),
                Container(
                  child: const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.black, //Color.fromARGB(255, 0, 255, 225)
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // print(MediaQuery.of(context).size.height);
                    // print(MediaQuery.of(context).size.width);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Signup()));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color:
                          Colors.pinkAccent, //Color.fromARGB(255, 0, 255, 225),
                    ),
                    child: const Center(
                        child: Text(
                      'Click here to Signup',
                      style: TextStyle(color: Colors.black),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  late String email;
  late String pass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, //Color.fromRGBO(16, 29, 37, 1),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: heightProp(100),
                ),
                const Text(
                  'Signup',
                  style: TextStyle(
                    //color: Color.fromRGBO(12, 169, 150, 1),
                    color: Color.fromRGBO(157, 165, 172, 1),
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(
                  height: heightProp(100),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      //color: Color.fromRGBO(12, 169, 150, 1),
                      color: Colors.white),
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.email,
                          //color: Color.fromRGBO(157, 165, 172, 1),
                        ),
                        hintText: 'Your email address?',
                        labelText: 'Email *',
                      ),
                      onChanged: (value) {
                        email = value;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: heightProp(50),
                ),
                Container(
                  // margin: EdgeInsets.only(left: 10),
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    //color: Color.fromRGBO(12, 169, 150, 1),
                    color: Colors.white,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    child: TextFormField(
                      obscureText: true,
                      decoration: const InputDecoration(
                        icon: Icon(
                          Icons.password,
                          //color: Color.fromRGBO(157, 165, 172, 1),
                        ),
                        hintText: 'Enter your password',
                        labelText: 'Password *',
                      ),
                      onChanged: (value) {
                        pass = value;
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: heightProp(200),
                ),
                TextButton(
                  onPressed: () async {
                    print(email);
                    print(pass);
                    try {
                      UserCredential userCredential = await FirebaseAuth
                          .instance
                          .createUserWithEmailAndPassword(
                              email: email, password: pass)
                          .then((value) {
                        print('account created succssfully');
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => signin()));
                        return value;
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 50,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.pink, //Color.fromRGBO(12, 169, 150, 1),
                    ),
                    child: const Center(
                        child: Text(
                      'Click here to create account',
                      style: TextStyle(color: Colors.black),
                    )),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
