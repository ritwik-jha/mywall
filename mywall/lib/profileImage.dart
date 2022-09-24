import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mywall/sizeFunctions.dart';
import 'package:mywall/wall.dart';

class profileImage extends StatefulWidget {
  String uid;
  String email;
  profileImage({required this.uid, required this.email});

  @override
  _profileImageState createState() =>
      _profileImageState(uid: this.uid, email: this.email);
}

class _profileImageState extends State<profileImage> {
  String email;
  File? profile;
  String uid;

  _profileImageState({required this.uid, required this.email});

  Future getImage(bool gallery) async {
    ImagePicker picker = ImagePicker();
    XFile? pickedFile;
    // Let user select photo from gallery
    if (gallery) {
      pickedFile = await picker.pickImage(source: ImageSource.gallery);
    }
    // Otherwise open camera to get new photo
    else {
      pickedFile = await picker.pickImage(
        source: ImageSource.camera,
      );
    }

    setState(() {
      if (pickedFile != null) {
        //_images.add(File(pickedFile.path));
        profile =
            File(pickedFile.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> saveImages(File _images, String uid) async {
    CollectionReference imagesRef =
        FirebaseFirestore.instance.collection('profileImages');

    imagesRef.doc(uid).set({
      "images": _images.path.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            Container(
              height: heightProp(46),
              width: widthProp(375),
              color: Colors.white,
              child: Row(
                children: [
                  SizedBox(
                    width: widthProp(10),
                  ),
                  const Icon(
                    Icons.close,
                    size: 35,
                  ),
                  SizedBox(
                    width: widthProp(10),
                  ),
                  const Text(
                    'Profile Photo',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: heightProp(200),
            ),
            profile == null
                ? Container(
                    height: heightProp(120.4),
                    width: heightProp(120.4),
                    margin: EdgeInsets.only(
                        top: heightProp(10.6), left: widthProp(0)),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60.2)),
                      color: Colors.grey,
                    ),
                  )
                : Container(
                    height: heightProp(120.4),
                    width: heightProp(120.4),
                    margin: EdgeInsets.only(
                        top: heightProp(10.6), left: widthProp(0)),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(60.2)),
                      color: Colors.grey,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60.0),
                      child: Image(
                        image: FileImage(profile!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            SizedBox(
              height: heightProp(200),
            ),
            profile == null
                ? InkWell(
                    onTap: () {
                      getImage(true);
                    },
                    child: Container(
                      height: 100,
                      width: 150,
                      decoration: const BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: const Center(
                        child: Text('Select Image'),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: () {
                      saveImages(profile!, uid);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  wall(uid: uid, email: email)));
                    },
                    child: Container(
                      height: 100,
                      width: 150,
                      decoration: const BoxDecoration(
                          color: Colors.pink,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: const Center(
                        child: Text('Save'),
                      ),
                    ),
                  )
          ],
        ),
      )),
    );
  }
}
