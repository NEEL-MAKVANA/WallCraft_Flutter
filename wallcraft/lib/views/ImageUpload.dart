import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';

class ImageUpload extends StatefulWidget {
  const ImageUpload({Key? key}) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  late String imageUrl;

  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    XFile? image;
    //Check Permissions
    await Permission.photos.request();

    // var permissionStatus = await Permission.photos.status;

    // if (permissionStatus.isGranted){
    //Select Image
    image = await _imagePicker.pickImage(source: ImageSource.gallery);
    var file = File(image?.path as String);
    var completePath = file.path;
    var fileName = (completePath.split('/').last);
    if (image != null) {
      //Upload to Firebase

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green.shade600,
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Code to execute.
          },
        ),
        content: const Text('Wallpaper uploaded successfuly'),
        duration: const Duration(milliseconds: 2500),
        // width: 280.0, // Width of the SnackBar.
        // padding: const EdgeInsets.symmetric(
        //   horizontal: 8.0, // Inner padding for SnackBar content.
        // ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 170,
            right: 20,
            left: 20),
      ));

      var snapshot = await _firebaseStorage
          .ref()
          .child('uploaded_wallpapers/${fileName}@${FirebaseAuth.instance.currentUser?.uid as String}')
          .putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
      });

    } else {
      print('No Image Path Received');
    }
    // } else {
    //   print('Permission not granted. Try Again with permission access');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Add your onPressed code here!
        uploadImage();
      },
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add_a_photo),
    );
  }
}
