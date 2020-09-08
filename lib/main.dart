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
  Widget build(BuildContext context) {
    return Container();
  }
}

