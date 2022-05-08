import 'package:flutter/material.dart';
import 'package:scanit/capture_screen/capture_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scanit/pdf_screen/pdf_screen.dart';
import 'package:scanit/file_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> itemList = ['Scan Images from Gallery', 'Scan by Camera'];
  String selectedItem = '';

  @override
  Widget build(BuildContext context) {
    selectedItem = ModalRoute.of(context)!.settings.arguments.toString();

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'SCAN IT',
            style: GoogleFonts.lato(
              fontSize: 27,
            ),
          ),
        ),
        // leading: IconButton(
        //   icon: Image.asset('assets/ScanIt.png'),
        //   onPressed: () {},
        // ),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                    //To wrap up Listview with Container > Center> Column> children <Widget> (to use BoxDecoration for Image) , use Expanded otherwise just inside body: Listview
                    padding:
                        const EdgeInsets.only(top: 10, right: 10, left: 10),
                    itemCount: itemList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 0,
                        child: ListTile(
                          tileColor: Colors.blue,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          title: Text(
                            itemList[index],
                            style: GoogleFonts.lato(),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CaptureScreen(),
                                  settings:
                                      RouteSettings(arguments: itemList[index]),
                                ));
                          },
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage(
              'assets/logo.png',
            ),
          ),
          // border: Border.all(
          //   color: Colors.black,
          //   width: 8,
          // ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PDFScreen(),
                    ));
              },
              heroTag: const Text("btn3"),
              label: const Text('Image Collection to PDF'),
              icon: const Icon(Icons.picture_as_pdf),
              backgroundColor: Colors.pink,
            ),
            const Spacer(),
            FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FileList(),
                    ));
              },
              heroTag: const Text("btn4"),
              label: const Text('FileList'),
              icon: const Icon(Icons.home),
              backgroundColor: Colors.pink,
            ),
          ],
        ),
      ),
    );
  }
}
