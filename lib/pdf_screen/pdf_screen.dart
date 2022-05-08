import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:scanit/file_list.dart';

class PDFScreen extends StatefulWidget {
  const PDFScreen({Key? key}) : super(key: key);

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  final pdf = pw.Document();
  String imagePath = 'asd';
  DateTime now = DateTime.now();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd").add_Hm();
  String fileName = '';
  bool isImageLoaded = false;
  late File pickedImage;

  final List<File> _image = [];

  @override
  void initState() {
    super.initState();
  }

  getImageFromGallery() async {
    final XFile? tempStore =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    pickedImage = File(tempStore!.path);

    setState(() {
      _image.add(File(tempStore.path));
      imagePath = tempStore.path.toString();
      isImageLoaded = true;
    });
  }

  getImageFromCamera() async {
    final XFile? tempStore =
        await ImagePicker().pickImage(source: ImageSource.camera);
    pickedImage = File(tempStore!.path);

    setState(() {
      _image.add(File(tempStore.path));
      imagePath = tempStore.path.toString();
      isImageLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Convert to PDF',
          style: GoogleFonts.lato(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                isImageLoaded ? createPDF() : null;
                isImageLoaded ? savePDF() : null;
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => const FileList(),
                //     ));
              },
              icon: const Icon(
                Icons.picture_as_pdf,
              ))
        ],
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2), //or ListView.builder
              itemCount: _image.length,
              itemBuilder: (context, index) => Container(
                height: 420,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.pink),
                ),
                padding: const EdgeInsets.all(7),
                child: Stack(
                  children: [
                    Image.file(
                      _image[index],
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: -4,
                      top: -3,
                      child: Container(
                          color: const Color.fromRGBO(196, 202, 206, 0.2),
                          child: IconButton(
                            onPressed: () {
                              _image.removeAt(index);
                              setState(() {});
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.indigo,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // floatingActionButton: FloatingActionButton.extended(
      //   label: const Text('Add Images'),
      //   icon :const Icon(Icons.add_a_photo,
      // color: Colors.pink,
      // ) ,
      //   onPressed: () {
      //
      //   getImageFromGallery();
      //   },),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            FloatingActionButton.extended(
              label: const Text('Capture Images'),
              icon: const Icon(
                Icons.camera,
                color: Colors.pink,
              ),
              onPressed: () {
                getImageFromCamera();
              },
              heroTag: 'btn1',
            ),
            const Spacer(),
            FloatingActionButton.extended(
              label: const Text('Add Images'),
              icon: const Icon(
                Icons.add_a_photo,
                color: Colors.pink,
              ),
              onPressed: () {
                getImageFromGallery();
              },
              heroTag: 'btn2',
            ),
          ],
        ),
      ),

      bottomNavigationBar: const BottomAppBar(
        child: Center(
          heightFactor: 4.0,
          child: Text(
            "Pick Images to make PDF Collection",
            style: TextStyle(
              fontSize: 10.0,
              color: Colors.pink,
            ),
          ),
        ),
      ),
    );
  }

  createPDF() async {
    for (var img in _image) {
      final image = pw.MemoryImage(img.readAsBytesSync());
      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            ); // Center
          }));
    }
  }

  savePDF() async {
    Directory directory;

    try {
      if (await _requestPermission(Permission.storage)) {
        setState(() {
          fileName += dateFormat.format(now);
          // fileName += '$now';
        });
        directory = (await getApplicationDocumentsDirectory());
        // print(directory.path);
        String newPath = "";
        List<String> folders = directory.path.split("/");
        for (int x = 1; x < folders.length; x++) {
          String folder = folders[x];
          if (folder != "Android") {
            newPath += "/" + folder;
          } else {
            break;
          }
        }
        newPath = newPath + "/ScanIT";
        directory = Directory(newPath);
        // print(directory.path);
      } else {
        return false;
      }
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File file = File('${directory.path}/$fileName.pdf');
        await file.writeAsBytes(await pdf.save());
        showPrintedMessage('success', 'saved to Documents');
      }
    } catch (e) {
      showPrintedMessage('error', e.toString());
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  showPrintedMessage(String title, String msg) {
    Flushbar(
      title: title,
      message: msg,
      duration: const Duration(seconds: 3),
      icon: const Icon(
        Icons.info,
        color: Colors.blue,
      ),
    ).show(context);
  }
}
