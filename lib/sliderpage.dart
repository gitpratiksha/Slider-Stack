import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:sliderstack/list.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class MySlider extends StatefulWidget {
  @override
  _MySliderState createState() => _MySliderState();
}

class _MySliderState extends State<MySlider> {
  bool pageloader = false;
  void loadingfunction() {
    setState(() {
      pageloader = true;
    });
    Future.delayed(Duration(seconds: 4), () {
      setState(() {
        pageloader = false;
      });
    });
  }

  final List<String> backsideimglist = [
    "https://thumbs.dreamstime.com/z/forest-mushroom-house-illustration-39116943.jpg",
    "https://image.shutterstock.com/image-vector/fairy-tales-village-small-houses-260nw-716505307.jpg",
    "https://i.ytimg.com/vi/I8-_WsvzDY8/hqdefault.jpg",
  ];
  final List<String> frontimglist = [
    "https://thumbs.gfycat.com/CookedBewitchedFlyingfox-max-1mb.gif",
    "https://www.animatedimages.org/data/media/327/animated-rabbit-image-0034.gif",
    "https://bestanimations.com/Animals/Insects/Butterflys/butterfly-animated.gif",
  ];
  Widget _swiperwidget() {
    return Container(
      height: 700,
      width: 500,
      child: Center(
        child: Stack(
          children: <Widget>[
            Swiper(
              autoplay: true,
              itemBuilder: (BuildContext context, int index) {
                return new Image.network(
                  backsideimglist[index],
                  fit: BoxFit.fill,
                );
              },
              itemCount: backsideimglist.length,
              pagination: new SwiperPagination(),
              control: new SwiperControl(),
            ),
            Center(
              child: Image.network(
                "https://www.animatedimages.org/data/media/1635/animated-walking-image-0019.gif",
                fit: BoxFit.fill,
              ),
            ),
            Swiper(
              autoplay: true,
              itemBuilder: (BuildContext context, int index) {
                return Align(
                  alignment: Alignment(-0.7, -0.1),
                  child: Image.network(
                    frontimglist[index],
                    fit: BoxFit.fill,
                    scale: 2.0,
                  ),
                );
              },
              itemCount: frontimglist.length,
              pagination: new SwiperPagination(),
              control: new SwiperControl(),
            ),
            RaisedButton(
              onPressed: loadingfunction,
              child: new Text('reload'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Slider'),
      ),
      body: ModalProgressHUD(child: _swiperwidget(), inAsyncCall: pageloader, progressIndicator: LinearProgressIndicator( 
      
       ),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          loadingfunction();
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MyPage()));
        },
        child: Icon(Icons.arrow_drop_up),
      ),
    );
  }
}
