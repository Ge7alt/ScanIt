import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';

class FileList extends StatefulWidget {
  const FileList({Key? key}) : super(key: key);

  @override
  State<FileList> createState() => _FileListState();
}

class _FileListState extends State<FileList> {
  late List<FileSystemEntity> _folders;
  Future<void> getDir() async {
    Directory directory;
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

    // final directory = await getApplicationDocumentsDirectory();
    // final dir = directory.path;

    // // final directory = await getExternalStorageDirectory();
    // // final dir = directory.path;
    // String? pdfDirectory = dir;
    // final myDir = Directory(pdfDirectory);
    setState(() {
      _folders = directory.listSync(recursive: true, followLinks: false);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _folders = [];
    getDir();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Files"),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 180,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          return Material(
            elevation: 6.0,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FutureBuilder(
                          future: getFileType(_folders[index]),
                          builder: (ctx, snapshot) {
                            // return Card(
                            //   child: IconButton(
                            //     icon: Icon(Icons.picture_as_pdf),
                            //     onPressed: (){
                            //       Navigator.push(context, MaterialPageRoute(builder: (context){

                            //     },
                            //   )

                            // );
                            return GestureDetector(
                              onTap: () => OpenFile.open(_folders[index].path),
                              child: const Icon(
                                Icons.picture_as_pdf_sharp,
                                size: 100,
                                color: Colors.red,
                              ),
                            );
                          }),
                      Text(
                        _folders[index].path.split('/').last,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: -4,
                  top: -3,
                  child: Container(
                      color: const Color.fromRGBO(196, 202, 206, 0.2),
                      child: IconButton(
                        onPressed: () {
                          _folders.removeAt(index);
                          //deleteFile(_folders[index]);
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete),
                        color: Colors.indigo,
                      )),
                ),
              ],
            ),
          );
        },
        itemCount: _folders.length,
      ),
    );
  }

  Future getFileType(file) {
    return file.stat();
  }

  // Future<int> deleteFile(file) async {
  //   try {
  //     final file = await _localFile;

  //     await file.delete();
  //   } catch (e) {
  //     return 0;
  //   }
  // }
}
