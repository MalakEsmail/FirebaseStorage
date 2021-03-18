import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_downloader/image_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _image;
  String _url;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Images'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: _image == null ? null : FileImage(_image),
                  radius: 80,
                ),
                GestureDetector(onTap: pickImage, child: Icon(Icons.camera))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: Text('Upload Image'),
                  onPressed: () {
                    uploadImage();
                  },
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  child: Text('Load Image'),
                  onPressed: loadImage,
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void pickImage() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    setState(() {
      _image = File(image.path);
    });
  }

  void uploadImage() async {
    try {
      FirebaseStorage storage = FirebaseStorage.instanceFor(
          bucket: 'gs://e-commerce-3aa37.appspot.com');
      Reference ref = storage.ref().child(p.basename(_image.path));
      UploadTask task = ref.putFile(_image);
      TaskSnapshot snapshot = await task.whenComplete(() => null);
      print('success');
      String url = await snapshot.ref.getDownloadURL();

      setState(() {
        _url = url;
      });
      print('url $url');
    } catch (ex) {
      print(ex.message);
    }
  }

  void loadImage() async {
    try {
      var imageId = await ImageDownloader.downloadImage(_url);
      var path = await ImageDownloader.findPath(imageId);
      File image = File(path);
      print('done');
      setState(() {
        _image = image;
      });
    } catch (ex) {
      print(ex.message);
    }
  }
}
