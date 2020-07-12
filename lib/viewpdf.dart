import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class MyPdf extends StatefulWidget {
  @override
  _MyPdfState createState() => _MyPdfState();
}

class _MyPdfState extends State<MyPdf> {
  String urlpdfpath = "";
  String assetpdfpath = "";
  String url = "http://www.pdf995.com/samples/pdf.pdf";

  @override
  void initState() {
    super.initState();
    getFileFromurl("http://www.pdf995.com/samples/pdf.pdf").then((f) {
      setState(() {
        urlpdfpath = f.path;
        print(urlpdfpath);
      });
    });
  }

  Future<File> getFileFromurl(String asset) async {
    try {
      var data = await http.get(url);
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
//File file=File('${dir.path}/myonline.pdf');
      File file = File('${dir.path}/myonline.pdf');
      File urlfile = await file.writeAsBytes(bytes);
      return urlfile;
    } catch (e) {
      throw Exception('Error opening url file');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('PDF'),
        bottom: MyLinearProgressIndicator(
          backgroundColor: Colors.orange,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                if (urlpdfpath != null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PdfViewerpage(path: urlpdfpath)));
                }
              },
              child: Text('url pdf'),
            ),
            RaisedButton(
              onPressed: () {},
              child: Text('btn2'),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfViewerpage extends StatefulWidget {
  final String path;

  const PdfViewerpage({Key key, this.path}) : super(key: key);
  @override
  _PdfViewerpageState createState() => _PdfViewerpageState();
}

class _PdfViewerpageState extends State<PdfViewerpage> {
  bool pdfready = false;
  int totalpages = 0;
  int currentpage = 0;
  PDFViewController _pdfViewController;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my page'),
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            autoSpacing: true,
            enableSwipe: true,
            pageSnap: true,
            swipeHorizontal: false,
            onError: (e) {
              print(e);
            },
            onRender: (_pages) {
              setState(() {
                totalpages = _pages;
                pdfready = true;
              });
            },
            onViewCreated: (PDFViewController vc) {
              _pdfViewController = vc;
            },
            onPageChanged: (int page, int total) {
              setState(() {});
            },
            onPageError: (page, e) {},
          ),
          !pdfready
              ? Center(
                  child: LinearProgressIndicator(),
                )
              : Offstage(),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          currentpage > 0
              ? Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FloatingActionButton(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.arrow_drop_up),
                      onPressed: () {
                        currentpage -= 1;
                        _pdfViewController.setPage(currentpage);
                      }),
                )
              : Offstage(),
          currentpage < totalpages
              ? FloatingActionButton(
                  backgroundColor: Colors.blue,
                  //  label: Text('GO TO ${currentpage+1}'),
                  child: Icon(Icons.arrow_drop_down),
                  onPressed: () {
                    currentpage += 1;
                    _pdfViewController.setPage(currentpage);
                  })
              : Offstage(),
        ],
      ),
    );
  }
}

const double _kMyLinearProgressIndicatorHeight = 6.0;

class MyLinearProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  MyLinearProgressIndicator({
    Key key,
    double value,
    Color backgroundColor,
    Animation<Color> valueColor,
  }) : super(
          key: key,
          value: value,
          backgroundColor: backgroundColor,
          valueColor: valueColor,
        ) {
    preferredSize = Size(double.infinity, _kMyLinearProgressIndicatorHeight);
  }

  @override
  Size preferredSize;
}
