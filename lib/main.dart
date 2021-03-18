import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  File _image;
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
                  onPressed: () {},
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  child: Text('Load Image'),
                  onPressed: () {},
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
}
