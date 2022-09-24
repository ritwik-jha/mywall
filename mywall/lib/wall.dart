import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mywall/profileImage.dart';
import 'package:mywall/sizeFunctions.dart';
import 'package:mywall/uploadPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class wall extends StatefulWidget {
  String email;
  String uid;
  wall({required this.uid, required this.email});

  @override
  _wallState createState() => _wallState(uid: this.uid, email: this.email);
}

class _wallState extends State<wall> {
  String email;
  String uid;
  List<Widget> content = [];
  List allData = [];
  File? profile;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  int count = 0;

  _wallState({required this.uid, required this.email});

  void getProfileImage() async {
    CollectionReference imageRef =
        FirebaseFirestore.instance.collection('profileImages');
    DocumentSnapshot query = await imageRef.doc(uid).get();
    setState(() {
      profile = File(query.get('images'));
    });
  }

  void createList() async {
    print('create list');
    print(uid);

    CollectionReference linksRef = FirebaseFirestore.instance.collection(uid);
    QuerySnapshot querySnapshot = await linksRef.get();

    // Get data from docs and convert map to List
    //print('list created !!!!');
    setState(() {
      allData = querySnapshot.docs.map((doc) => doc.data()).toList();
      if (allData.length != 0) {
        print('adding palletes');
        print(allData);
        count = allData.length;
        for (int i = 0; i < allData.length; i++) {
          content.add(pallete(
            file: File(allData[i]['images']),
            caption: allData[i]['caption'],
            location: allData[i]['location'],
            date: allData[i]['date'],
          ));
        }
      } else {
        print('empty list');
      }
    });
    print(allData);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //createUsername();
    getProfileImage();
    content.clear();
    createList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: Text('data'),
      //   backgroundColor: Colors.white,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: heightProp(46),
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: heightProp(10.8), left: widthProp(10.8)),
                    child: const Text(
                      'MyWall',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: widthProp(9.75)),
                    child: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
            content.length != 0
                ? SingleChildScrollView(
                    child: Container(
                      height: heightProp(672.4),
                      child: ListView(
                        children: [
                          Container(
                            height: heightProp(200.9),
                            width: double.infinity,
                            color: Colors.white,
                            child: Column(
                              children: [
                                profile == null
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      profileImage(
                                                        uid: uid,
                                                        email: email,
                                                      )));
                                        },
                                        child: Container(
                                          height: heightProp(120.4),
                                          width: heightProp(120.4),
                                          margin: EdgeInsets.only(
                                              top: heightProp(10.6),
                                              left: widthProp(0)),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(60.2)),
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        height: heightProp(120.4),
                                        width: heightProp(120.4),
                                        margin: EdgeInsets.only(
                                            top: heightProp(10.6),
                                            left: widthProp(0)),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(60.2)),
                                          color: Colors.grey,
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(60.0),
                                          child: Image(
                                            image: FileImage(profile!),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Text(
                                    "@${email.split('@')[0]}",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      //fontWeight: FontWeight.w600
                                    ),
                                  ),
                                ),
                                // Container(
                                //   child: const Text('@handle'),
                                // )
                              ],
                            ),
                          ),
                          Column(
                            children: content,
                          )
                        ],
                      ),
                    ),
                  )
                : Container(
                    height: heightProp(672.4),
                    child: Column(
                      children: [
                        Container(
                          height: heightProp(200.9),
                          width: double.infinity,
                          color: Colors.white,
                          child: Column(
                            children: [
                              Container(
                                height: heightProp(120.4),
                                width: heightProp(120.4),
                                margin: EdgeInsets.only(
                                    top: heightProp(10.6), left: widthProp(0)),
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(60.2)),
                                  color: Colors.grey,
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  "@${email.split('@')[0]}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    //fontWeight: FontWeight.w600
                                  ),
                                ),
                              ),
                              // Container(
                              //   child: const Text('@handle'),
                              // )
                            ],
                          ),
                        ),
                        Container(
                          child: const Center(
                              child: Text('Nothing to show, Add images..')),
                        ),
                      ],
                    ),
                  ),
            Container(
              height: 70,
              width: widthProp(375),
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    width: widthProp(375),
                    height: 1,
                    color: Colors.black,
                  ),
                  SizedBox(
                    height: heightProp(11.87),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: widthProp(19.51),
                      ),
                      const Icon(
                        Icons.home,
                        size: 35,
                      ),
                      SizedBox(
                        width: widthProp(115),
                      ),
                      const Icon(
                        Icons.search,
                        size: 35,
                      ),
                      SizedBox(
                        width: widthProp(115),
                      ),
                      InkWell(
                        onTap: () {
                          print(count.toString());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => uploadPage(
                                        uid: uid,
                                        count: count + 1,
                                        email: email,
                                      )));
                        },
                        child: const Icon(
                          Icons.add_a_photo,
                          size: 35,
                        ),
                      ),
                      // SizedBox(
                      //   width: widthProp(60),
                      // ),
                      // const Icon(
                      //   Icons.pages,
                      //   size: 35,
                      // ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class pallete extends StatefulWidget {
  File file;
  String caption;
  String location;
  String date;
  pallete(
      {required this.file,
      required this.caption,
      required this.location,
      required this.date});

  @override
  _palleteState createState() => _palleteState(
        file: this.file,
        caption: this.caption,
        location: this.location,
        date: this.date,
      );
}

class _palleteState extends State<pallete> {
  File file;
  String caption;
  String location;
  String date;
  _palleteState(
      {required this.file,
      required this.caption,
      required this.location,
      required this.date});

  bool fileExists(File file) {
    return File(file.path).existsSync();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            height: heightProp(36),
            width: widthProp(375),
            child: Row(
              children: [
                // Container(
                //   height: 35,
                //   width: 35,
                //   margin: const EdgeInsets.only(
                //     left: 10.25,
                //     //bottom: 6.25, top: 2.25
                //   ),
                //   decoration: const BoxDecoration(
                //       color: Colors.grey,
                //       borderRadius: BorderRadius.all(Radius.circular(17.5))),
                // ),
                SizedBox(
                  width: widthProp(10.25),
                ),
                const Icon(
                  Icons.location_city,
                  size: 35,
                ),
                SizedBox(
                  width: widthProp(10.25),
                ),
                Text(
                  location,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          SizedBox(
            height: heightProp(6.25),
          ),
          fileExists(file)
              ? Container(
                  color: Colors.yellow,
                  width: widthProp(375),
                  height: heightProp(375),
                  child: Image(
                    fit: BoxFit.cover,
                    image: FileImage(file),
                  ))
              : Container(
                  width: widthProp(375),
                  height: heightProp(375),
                  color: Colors.grey,
                ),
          Container(
            height: heightProp(46),
            child: Row(
              children: [
                SizedBox(width: widthProp(8)),
                const Text(
                  'Uploaded on  ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: [
                SizedBox(width: widthProp(8)),
                const Text(
                  '@handle ',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  caption,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: heightProp(16),
          )
        ],
      ),
    );
  }
}
