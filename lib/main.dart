import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'dart:typed_data'; //to access Uint8List class

import 'package:flutter/services.dart' show rootBundle;

//importing web file based on condition
import 'mobile.dart' if (dart.library.html) 'web.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
        child: Text("Create PDF"),
        onPressed: _createPdf,
      ),
    ));
  }

  Future<void> _createPdf() async {
    //Defining a pdf object
    PdfDocument document = PdfDocument();

    //to create pdf page within document and creating an object of it
    final page = document.pages.add();

    //adding text to pdf
    page.graphics.drawString(
        "Srijan's PDF", PdfStandardFont(PdfFontFamily.timesRoman, 35));

    //adding image to pdf
    page.graphics.drawImage(
        PdfBitmap(await _readImageData('market.png')),
        //detail about area to draw image
        Rect.fromLTWH(0, 100, 440, 550));

    //adding table
    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 30),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

    grid.columns.add(count: 3);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = "Roll no";
    header.cells[1].value = "Name";
    header.cells[2].value = "Class";

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = "1";
    row.cells[1].value = "Arya";
    row.cells[2].value = "6";

    row = grid.rows.add();
    row.cells[0].value = "2";
    row.cells[1].value = "John";
    row.cells[2].value = "9";

    row = grid.rows.add();
    row.cells[0].value = "3";
    row.cells[1].value = "Tony";
    row.cells[2].value = "12";

    grid.draw(
        //to add table in 2nd page of pdf
        page: document.pages.add(),
        bounds: const Rect.fromLTWH(0, 0, 0, 0));

    //to save pdf we need to define it as bytes or list of int
    List<int> bytes = document.save();

    //document disposed to release all resources used by it
    document.dispose();

    saveAndLaunchFile(bytes, "Output.pdf");
  }
}

Future<Uint8List> _readImageData(String name) async {
  //to load image rootBundle is used

  final data = await rootBundle.load('images/$name');

  //return image file as Uint8List type
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}
