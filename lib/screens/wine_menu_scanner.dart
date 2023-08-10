import 'package:bubu_parker_scanner/screens/wine_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/image_processing_service.dart';
import '../services/web_scraping_service.dart';
import '../models/wine.dart';

class WineMenuScanner extends StatefulWidget {
  @override
  _WineMenuScannerState createState() => _WineMenuScannerState();
}

class _WineMenuScannerState extends State<WineMenuScanner> {
  final picker = ImagePicker();
  File? _image;
  List<Wine>? _wines;
  String? _wineName; // Add this line

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Wine Menu Scanner'),
        ),
        body: Column(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _image == null ? Text('No image selected.') : Image.file(_image!),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: getImageFromCamera,
                        child: Text('Take a picture'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: getImageFromGallery,
                        child: Text('Choose from gallery'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    // onPressed: () {
                    //   scrapeRatings(["2020 Alvaro Palacios, 'Finca Dofi'"]);
                    // },
                    onPressed: processImage,
                    child: Text('Process image'),
                  ),
                ],
              ),
            ),
            TextField(
              onChanged: (value) => _wineName = value,
              decoration: InputDecoration(
                labelText: 'Wine Name',
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  if (_wineName != null) {
                    print("Button pressed");
                    final wine = scrapeRating(_wineName!);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WineListScreen(),
                      ),
                    );
                  }
                },
                child: Text('Search Wine')),
          ],
        ));
  }

  Future<void> getImageFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> getImageFromGallery() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> processImage() async {
    var text = await extractTextFromImage(_image!);
    // This actually works, but for now I will just cat like there is a wine
    // text = "2020 Alvaro Palacios, 'Finca Dofi'";
    if (text != null) {
      // Skipping this for now, cause i only wanna test one wine
      final wineNames = extractWineNames(text);

      // List<String> wineNames = ["2020 Alvaro Palacios, 'Finca Dofi'"];
      final wines = await scrapeRating(wineNames);
      setState(() {
        _wines = wines;
      });
    } else {
      print("NO WINES FOUND");
    }
  }

  List<String> extractWineNames(String text) {
    final lines = text.split('\n');
    final wineNames = <String>[];

    for (final line in lines) {
      // #TODO: HEIR SOLLTE MAN IRGENDWIE TESTEN OB ES EIN WEIN ODER NUR UNNÖTIGER TEXZT IST
      wineNames.add(line.trim());
    }

    return wineNames;
  }
}
