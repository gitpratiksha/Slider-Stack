import 'package:flutter/material.dart';
import 'dart:async';

//import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> animated;
  Animation<Offset> _offsetAnimation;
  final listkey = GlobalKey<AnimatedListState>();
  bool pageloader;
  var progress = 0;
  var progressval = 0;

  final List<String> europeanCountries = [
    'Albania',
    'Andorra',
    'Armenia',
    'Austria',
    'Azerbaijan',
    'Belarus',
    'Belgium',
    'Bosnia and Herzegovina',
    'Bulgaria',
    'Croatia',
    'Cyprus',
    'Czech Republic',
    'Denmark',
    'Estonia',
    'Finland',
    'France',
    'Georgia',
    'Germany',
    'Greece',
    'Hungary',
    'Iceland',
    'Ireland',
    'Italy',
  ];
 final List progresslist=[];

  Widget _linearloader() {
    return LinearPercentIndicator(
      width: MediaQuery.of(context).size.width - 50,
      animation: true,
      lineHeight: 20.0,
      animationDuration: 2500,
      percent: 0.8,
      center: Text('$progress'),
      linearStrokeCap: LinearStrokeCap.roundAll,
      progressColor: Colors.green,
    );
  }

  void setprogress() {
    var i;
    for (i = 1; i <= 10; i++) {
      setState(() {
      
          progress = i * 10;
          print(progress);    
      });
    
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      pageloader = true;
    });
    Future.delayed(Duration(seconds: 20), () {
      setState(() {
        pageloader = false;
        print(pageloader);
      });
    });
    _controller = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this)
      ..repeat(reverse: true);
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));
setprogress();
  //  Timer.periodic(Duration(seconds: 2), (Timer t) => setprogress());
  }

  onTapDelete() {
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  mylist(contry, index) {
    return ListTile(
      title: Text(contry),
      trailing: RaisedButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          onPressed: () {
            //print(index);

            setState(() {
              print(index);
              String itemToRemove = europeanCountries.removeAt(index);
              listkey.currentState.removeItem(
                index,
                (BuildContext context, Animation<double> animation) =>
                    _buildItem(context, itemToRemove, animation),
                duration: const Duration(milliseconds: 700),
              );
            });
          },
          child: Icon(Icons.delete)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.pink[50],
            child: AnimatedList(
                key: listkey,
                initialItemCount: europeanCountries.length,
                itemBuilder: (context, index, animation) {
                  return
                      // position:_animation,
                      mylist(europeanCountries[index], index);
                }),
          ),
          Visibility(
            visible: pageloader,
            child: Center(
              child: _linearloader(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(
      BuildContext context, String item, Animation<double> animation) {
    TextStyle textStyle = new TextStyle(fontSize: 20);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizeTransition(
        sizeFactor: animation,
        axis: Axis.vertical,
        child: SizedBox(
          height: 50.0,
          child: Card(
            color: Colors.black,
            child: Center(
              child: Text('$progress', style: textStyle),
            ),
          ),
        ),
      ),
    );
  }

//////////////////
  Widget _buildItemscaletrans(
      BuildContext context, String item, Animation<double> animation) {
    TextStyle textStyle = new TextStyle(fontSize: 20);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ScaleTransition(
        scale: animation,
        alignment: Alignment.center,
        child: SizedBox(
          height: 50.0,
          child: Card(
            color: Colors.black,
            child: Center(
              child: Text('', style: textStyle),
            ),
          ),
        ),
      ),
    );
  }

  ////////////////
  Widget _buildItemslidetrans(
      BuildContext context, String item, Animation<double> animation) {
    TextStyle textStyle = new TextStyle(fontSize: 20);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SlideTransition(
        position: _offsetAnimation,
        child: SizedBox(
          height: 50.0,
          child: Card(
            color: Colors.black,
            child: Center(
              child: Text('', style: textStyle),
            ),
          ),
        ),
      ),
    );
  }
}
