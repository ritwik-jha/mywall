//import 'dart:html';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlng/latlng.dart';
import 'package:mywall/sizeFunctions.dart';
import 'package:mywall/wall.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class uploadPage extends StatefulWidget {
  String email;
  String uid;
  int count;
  uploadPage({required this.count, required this.uid, required this.email});

  @override
  _uploadPageState createState() =>
      _uploadPageState(count: this.count, uid: this.uid, email: this.email);
}

class _uploadPageState extends State<uploadPage> {
  int count;
  String uid;
  String email;

  _uploadPageState(
      {required this.count, required this.uid, required this.email});

  File? _image;
  String? captions;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // void createReference() async {
  //   final SharedPreferences prefs = await _prefs;
  //   String? collectionName = prefs.getString('uid');
  //   linksRef = FirebaseFirestore.instance.collection(collectionName!);
  // }

  Future<void> saveImages(File _images, String caption, int count,
      String location, String date, String uid) async {
    CollectionReference linksRef = FirebaseFirestore.instance.collection(uid);
    String documentName = "upload${count.toString()}";

    linksRef.doc(documentName).set({
      "images": _images.path.toString(),
      "caption": caption,
      "location": location,
      "date": date
    });
  }

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
        _image = File(pickedFile.path); // Use if you only need a single picture
      } else {
        print('No image selected.');
      }
    });
  }

  late String currentPostion;
  late String location;
  bool gotPosition = false;

  void _getUserLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      var position = await GeolocatorPlatform.instance.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      // GeoData data = await Geocoder2.getDataFromCoordinates(
      //     latitude: position.latitude,
      //     longitude: position.longitude,
      //     googleMapApiKey: 'AIzaSyAgnS8L_vd2YrIwPdato5mWG7j8R3VCZ_s');
      setState(() {
        currentPostion =
            '${placemarks[0].locality}, ${placemarks[0].administrativeArea}';
        gotPosition = true;
      });
    } else {
      throw Exception('Error');
    }
    // return await Geolocator.getCurrentPosition();

    //
  }

  String getMonth(int i) {
    switch (i) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
    }
    return 'hux';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //createReference();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Upload Image'),
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                      'New Photo',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 500,
                width: double.infinity,
                //color: Colors.yellow,
                //margin: EdgeInsets.all(20),
                child: Container(
                  height: 250,
                  width: 200,
                  //margin: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                    //borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: _image != null
                      ? Image(
                          image: FileImage(_image!),
                          fit: BoxFit.cover,
                        )
                      : Container(),
                ),
              ),
              _image == null
                  ? const SizedBox(
                      height: 80,
                    )
                  : Container(
                      margin: const EdgeInsets.only(bottom: 30, top: 30),
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
                              Icons.text_fields,
                              //color: Color.fromRGBO(157, 165, 172, 1),
                            ),
                            hintText: 'Caption for this image',
                            labelText: 'Caption *',
                          ),
                          onChanged: (value) {
                            captions = value;
                          },
                        ),
                      ),
                    ),
              _image == null
                  ? InkWell(
                      onTap: () {
                        getImage(true);
                      },
                      child: Container(
                        height: 100,
                        width: 150,
                        decoration: const BoxDecoration(
                            color: Colors.pink,
                            borderRadius:
                                BorderRadius.all(Radius.circular(50))),
                        child: const Center(
                          child: Text(
                            'Add Image',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    )
                  : Row(
                      children: [
                        SizedBox(
                          width: widthProp(25),
                        ),
                        InkWell(
                          onTap: () {
                            _getUserLocation();
                            print('coordinates fetched');
                          },
                          child: Container(
                            child: Icon(Icons.gps_fixed),
                          ),
                        ),
                        SizedBox(
                          width: widthProp(10),
                        ),
                        gotPosition == false
                            ? Container()
                            : Container(
                                child: Text(
                                  "${currentPostion}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                        Spacer(),
                        InkWell(
                          onTap: () {
                            //getImage(true);
                            saveImages(
                                    _image!,
                                    captions!,
                                    count,
                                    currentPostion,
                                    '${getMonth(DateTime.now().month)} ${DateTime.now().day}, ${DateTime.now().year}',
                                    uid)
                                .then((value) {
                              print('done!!!!!');
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => wall(
                                            uid: uid,
                                            email: email,
                                          )));
                            });
                          },
                          child: Container(
                            height: 100,
                            width: 150,
                            decoration: const BoxDecoration(
                                color: Colors.pink,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50))),
                            child: const Center(
                              child: Text('Upload image'),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: widthProp(15),
                        ),
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
