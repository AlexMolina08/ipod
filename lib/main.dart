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
          SizedBox(height: 120.0),
          Center(
              child: Stack(alignment: Alignment.center,
              children: [
                GestureDetector(
                  onPanUpdate: (e) => _panHandler(e),
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
                          child: Text('MENU',
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
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
                        ),
                        Container(
                          child: IconButton(
                            icon: Icon(Icons.fast_rewind),
                            iconSize: 40.0,
                            onPressed: () => _pageCtrl.animateToPage(
                                (_pageCtrl.page - 1).toInt(),
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.only(left: 30),
                        ),
                        Container(
                          child: Icon(
                            Icons.play_arrow,
                            size: 40.0,
                          ),
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(bottom: 30),
                        ),
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

  void _panHandler(DragUpdateDetails d) {
    double radius = 150;

    //sabemos que el user está arriba del circulo si la posicion local es <= al radio
    bool onTop = d.localPosition.dy <= radius;
    bool onLeftSide = d.localPosition.dx <= radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    //Panel Movements

    bool panUp = d.delta.direction <= 0.0;
    bool panelLeft = d.delta.dx <= 0.0;
    bool panRight = !panelLeft;
    bool panDown = !panUp;

    //Absolute change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : xChange * -1;

    double horizontalRotation =
        (onTop & panRight) || (onBottom && panelLeft) ? yChange : xChange * -1;

    double rotationalChange =
        (verticalRotation + horizontalRotation) * (d.delta.distance * 0.2);

    _pageCtrl.jumpTo(_pageCtrl.offset + rotationalChange);
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
