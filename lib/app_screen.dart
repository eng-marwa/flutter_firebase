import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iti_flutter/AppUser.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  late FirebaseAuth _auth;
  late DatabaseReference _dbRef;
  late Reference _reference;
  String uid = '';
  String email = '';
  String url = '';

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _dbRef = FirebaseDatabase.instance.ref();
    uid = _auth.currentUser!.uid;
    email = _auth.currentUser!.email!;
    _reference = FirebaseStorage.instance.ref();
    viewUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        TextButton(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            Navigator.pushNamed(context, '/');
          },
          child: Text('Log Out'),
        )
      ]),
      body: Center(
        child: Column(children: [
          Text('User Data'),
          ElevatedButton(
              onPressed: () => _saveUserData(), child: Text('Save User Data')),
          Visibility(
            child: Image.network(url),
            visible: url.isNotEmpty,
          ),
          ElevatedButton(
              onPressed: () => uploadImage(), child: Text('Select Image')),
          ElevatedButton(onPressed: (){}, child: Text('Save User Data Firestore')),
          ElevatedButton(
              onPressed: () {
                // FirebaseCrashlytics.instance.crash();
                throw Error();
              },
              child: Text('Test'))
        ]),
      ),
    );
  }

  _saveUserData() async {
    AppUser user = AppUser(uid, email, '645949562', 'marwa');
    try {
      _dbRef
          .child('users')
          .child(uid)
          .set(user.toMap())
          .whenComplete(() => print('Done'));
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  void viewUserData() {
    try {
      _dbRef.child('users').child(uid).onValue.listen((DatabaseEvent event) {
        // print(event.snapshot.value);
        // print(event.snapshot.value.runtimeType);
        Map<String, dynamic> userMap =
            Map.from(event.snapshot.value as Map<Object?, Object?>);
        // print(userMap);
        // print(userMap.runtimeType);
        print(AppUser.fromMap(userMap));
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  Future<File?> _pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: ImageSource.camera);
    if (xFile != null) {
      // print(xFile.path);
      File file = File(xFile.path);
      return file;
    }
    return null;
  }

  Future<void> uploadImage() async {
    File? file = await _pickImage();
    List<String>? list = file?.path.split('.');
    String ext = '';
    if (list?.length != 0) {
      ext = list![list.length - 1];
      print(ext);
    }
    var dateTime = DateTime.now();
    if (file != null) {
      UploadTask task =
          _reference.child('images/$uid/$dateTime.$ext').putFile(file);
      task.whenComplete(() async {
        try {
          var downloadUrl = await task.snapshot.ref.getDownloadURL();
          setState(() {
            url = downloadUrl;
          });
        } on FirebaseException catch (e) {
          print(e.message);
        }
      });
      print(url);
    }
  }
}
