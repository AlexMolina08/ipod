import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        title: 'iPod',
        home: Scaffold(body: MyIpod()));
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
                itemCount: 5,
                itemBuilder: (context, int currentIndx) {
                  return AlbumCard(
                      color: Colors.accents[currentIndx],
                      currentIndx: currentIndx,
                      currentPage: currentPage);
                },
              )),
          Spacer(),
          Center(
              child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onPanUpdate: (e) => null,
                child: Container(
                  height: 300.0,
                  width: 300.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Stack(
                    children: [
                      Container(
                        child: Text('MENU',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold)),
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 36),
                      ),
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.fast_forward),
                          iconSize: 40.0,
                          onPressed: () => _pageCtrl.animateToPage(
                              (_pageCtrl.page + 1).toInt(),
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeIn),
                        ),
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.only(right: 30),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                height: 100.0,
                width: 100.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white38,
                ),
              )
            ],
          )),
        ],
      ),
    );
  }
}

class AlbumCard extends StatelessWidget {
  final Color color;
  final int currentIndx;
  final double currentPage;

  AlbumCard({this.color, this.currentPage, this.currentIndx});

  @override
  Widget build(BuildContext context) {
    double relativePosition = currentIndx - currentPage;

    return Container(
      width: 250,
      child: Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.003) //añadir perspectiva
            ..scale((1 - relativePosition.abs()).clamp(0.2, 0.6) + 0.4)
            ..rotateY(relativePosition),
          alignment: relativePosition >= 0
              ? Alignment.centerLeft
              : Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.fromLTRB(5, 20, 5, 20),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: color,
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('images/album$currentIndx.jpg'))),
          )),
    );
  }
}
