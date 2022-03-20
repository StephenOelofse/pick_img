import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? image;

  Future pickImage(ImageSource imagesrc) async {
    try {
      final image = await ImagePicker().pickImage(source: imagesrc);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('failed to pick an image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image != null
                ? ClipOval(
                    child: Image.file(
                      image!,
                      width: 160,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  )
                : const FlutterLogo(size: 130),
            const SizedBox(
              height: 25,
            ),
            Text(
              'Image Picker',
              style: Theme.of(context).textTheme.headline3,
            ),
            const SizedBox(
              height: 30,
            ),
            buttonBuild(
                context,
                'Pick Galary',
                const Icon(Icons.image_outlined),
                () => pickImage(ImageSource.gallery)),
            const SizedBox(
              height: 20,
            ),
            buttonBuild(
                context,
                'Pick Camera',
                const Icon(Icons.camera_alt_outlined),
                () => pickImage(ImageSource.camera))
          ],
        ),
      ),
    );
  }
}

@override
Widget buttonBuild(BuildContext context, title, icon, onPressed) {
  Size screenSize = MediaQuery.of(context).size;

  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: icon,
    label: Text(title),
    style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(screenSize.width / 2, 20))),
  );
}
