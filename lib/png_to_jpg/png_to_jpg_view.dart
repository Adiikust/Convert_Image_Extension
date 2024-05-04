import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class PngTOJpgView extends StatefulWidget {
  const PngTOJpgView({super.key});

  @override
  State<PngTOJpgView> createState() => _PngTOJpgViewState();
}

class _PngTOJpgViewState extends State<PngTOJpgView> {
  ImageFormat _selectedFormat = ImageFormat.jpg;
  final ImagePicker picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Png to Jpg"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                await _pickImage();
              },
              child: Container(
                height: 220,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    image: DecorationImage(
                        image: FileImage(
                            File(_imageFile?.path.toString() ?? "")))),
              ),
            ),
            Text(_imageFile?.path.split('/').last ?? ""),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DropdownButton<ImageFormat>(
                  value: _selectedFormat,
                  onChanged: (value) {
                    setState(() {
                      _selectedFormat = value!;
                    });
                  },
                  items: ImageFormat.values.map((ImageFormat format) {
                    return DropdownMenuItem<ImageFormat>(
                      value: format,
                      child:
                          Text(format.toString().split('.').last.toUpperCase()),
                    );
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_imageFile != null) {
                      String outputFileName =
                          'adnan.${_selectedFormat.toString().split('.').last}';
                      String outputFilePath =
                          await _getLocalFilePath(outputFileName);
                      await convertImage(
                        inputFile: _imageFile!,
                        outputFile: outputFilePath,
                        outputFormat: _selectedFormat,
                      );
                      setState(() {
                        _imageFile = File(outputFilePath);
                      });
                    } else {
                      print('No image selected.');
                    }
                  },
                  child: const Text("Convert"),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 220,
              width: double.maxFinite,
              color: Colors.black38,
            ),
            Text(_imageFile?.path.split('/').last ?? ""),
          ],
        ),
      ),
    );
  }

  // Method to get local file path
  Future<String> _getLocalFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  Future<void> convertImage(
      {required File inputFile,
      required String outputFile,
      required ImageFormat outputFormat}) async {
    Uint8List inputBytes = await inputFile.readAsBytes();
    img.Image? inputImage = img.decodeImage(inputBytes);
    Uint8List? outputBytes;
    switch (outputFormat) {
      case ImageFormat.jpg:
        outputBytes = img.encodeJpg(inputImage!) as Uint8List?;
        print("############### mageFormat.jpg $outputBytes");
        print("############### mageFormat.jpg $outputFile");
        print("############### mageFormat.jpg $outputFormat");
        break;
      case ImageFormat.png:
        outputBytes = img.encodePng(inputImage!) as Uint8List?;
        print("############### mageFormat.png $outputBytes");
        print("############### mageFormat.png $outputFile");
        print("############### mageFormat.png $outputFormat");
        break;
    }
    await File(outputFile).writeAsBytes(outputBytes!);
  }
}

enum ImageFormat {
  jpg,
  png,
}
