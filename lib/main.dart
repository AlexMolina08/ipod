import 'package:flutter/material.dart';


void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(brightness: Brightness.dark),
      title: 'iPod',
      home: Scaffold(
        body:MyIpod()
      )
    );
  }
}


class MyIpod extends StatefulWidget {
  @override
  _MyIpodState createState() => _MyIpodState();
}

class _MyIpodState extends State<MyIpod> {

  final PageController _pageCtrl = PageController(viewportFraction: 0.6);
  double currentPage = 0.0;

  @override
  void initState() {
    _pageCtrl.addListener(() {
      setState(() {
        currentPage = _pageCtrl.page;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            height: 300.0,
            color: Colors.black,
            child: PageView.builder(
              controller: _pageCtrl,
              scrollDirection: Axis.horizontal,
              itemCount: 9,
              itemBuilder: (context , int currentIndx){
                return AlbumCard(
                  color: Colors.accents[currentIndx],
                  currentIndx: currentIndx,
                  currentPage : currentPage
                );
              },
            )
          )
        ],
      ),
    );
  }
}

class AlbumCard extends StatelessWidget {

  final Color color;
  final int currentIndx;
  final double currentPage;

  AlbumCard({this.color,this.currentPage,this.currentIndx});

  @override
  Widget build(BuildContext context) {
    double relativePosition = currentIndx - currentPage;

    return Container(
      width: 250,
      child: Transform(
        transform: Matrix4.identity(),
      ),
    );
  }
}
