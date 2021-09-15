import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:holding_gesture/holding_gesture.dart';

import 'package:holding_gesture/holding_gesture.dart';

class ScannerPage extends StatefulWidget {
  ScannerPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _ScannerPageState createState() => _ScannerPageState();
}

enum CarouselState { Waiting, Begun, Ended }

class _ScannerPageState extends State<ScannerPage>
    with SingleTickerProviderStateMixin {
  // 15 different jobs
  final CarouselController _controller = CarouselController();
  late AnimationController animationController;

  int autoplayInterval = 0; // Duration(milliseconds: 100)
  int autoPlayAnimationDuration = 0; //  Duration(milliseconds: 200)
  bool playCarousel = false;
  bool showCarousel = false;
  bool isFinished = false;
  CarouselState scannerState = CarouselState.Waiting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    setAnimationSpeed(400, 600);
  }

  void setAnimationSpeed(int interval, int animationDuration) {
    setState(() {
      autoplayInterval = interval;
      autoPlayAnimationDuration = animationDuration;
    });
  }

  int superFast = 200;
  int fast = 250;
  int medium = 300;
  int slow = 600;

  void beginCarousel() async {
    print("starting");
    setState(() {
      showCarousel = true;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      playCarousel = true;
    });

    for (int i = 0; i < 5; i++) {
      _controller.nextPage(
          duration: Duration(milliseconds: fast), curve: Curves.linear);
      await Future.delayed(Duration(milliseconds: fast));
    }
    for (int i = 0; i < 10; i++) {
      _controller.nextPage(
          duration: Duration(milliseconds: fast), curve: Curves.linear);
      await Future.delayed(Duration(milliseconds: fast));
    }
    endCarousel();
  }

  void endCarousel() async {
    print("..Ending..");
    var rng = new Random();
    int selectedJob = rng.nextInt(10);
    print("Job selected: $selectedJob");
    print("15+$selectedJob = ${10 + selectedJob}");
    setState(() {
      playCarousel = false;
    });
    for (int i = 0; i < selectedJob; i++) {
      _controller.nextPage(
          duration: Duration(milliseconds: slow), curve: Curves.linear);
      await Future.delayed(Duration(milliseconds: slow));
    }
    setState(() {
      isFinished = true;
      scannerState = CarouselState.Ended;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: content());
  }

  Widget content() {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("Assets/scanner.png"), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOutCubic,
              top: (scannerState == CarouselState.Begun ||
                  scannerState == CarouselState.Ended)
                  ? MediaQuery.of(context).size.height / 8
                  : -500,
              child: Container(
                  height: 380,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey.withOpacity(0.5),
                  child: CarouselSlider(
                    options: CarouselOptions(
                        initialPage: 0,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        height: 360,
                        enableInfiniteScroll: true,
                        autoPlay: playCarousel,
                        autoPlayInterval:
                        Duration(milliseconds: autoplayInterval),
                        autoPlayAnimationDuration:
                        Duration(milliseconds: autoPlayAnimationDuration),
                        autoPlayCurve: Curves.easeInOutCubic),
                    carouselController: _controller,
                    items: [
                      jobCard("animationskunstner.png"),
                      jobCard("ansvarlig_for_gæringstank.png"),
                      jobCard("arbejdsleder_for_vævemaskiner.png"),
                      jobCard("aromaterapeut.png"),
                      jobCard("astronaut.png"),
                      jobCard("balletpædagog.png"),
                      jobCard("blogger.png"),
                      jobCard("dyrepasser.png"),
                      jobCard("hundemadstester.png"),
                      jobCard("influencer.png"),
                      jobCard("klargører.png"),
                      jobCard("negletekniker.png"),
                      jobCard("spion.png"),
                      jobCard("typograf.png"),
                      jobCard("youtuber.png"),
                      jobCard("animationskunstner.png"),
                      jobCard("ansvarlig_for_gæringstank.png"),
                      jobCard("arbejdsleder_for_vævemaskiner.png"),
                      jobCard("aromaterapeut.png"),
                      jobCard("astronaut.png"),
                      jobCard("balletpædagog.png"),
                      jobCard("blogger.png"),
                      jobCard("dyrepasser.png"),
                      jobCard("hundemadstester.png"),
                      jobCard("influencer.png"),
                      jobCard("klargører.png"),
                      jobCard("negletekniker.png"),
                      jobCard("spion.png"),
                      jobCard("typograf.png"),
                      jobCard("youtuber.png"),
                    ],
                  ))),
          Positioned(
              top: 544,
              child: GestureDetector(
                onLongPressEnd: (_) {
                  print("AW LAWD");
                  scannerState = CarouselState.Begun;
                  beginCarousel();
                },
                child: Container(
                    height: 250,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.3),
                        borderRadius: BorderRadius.all(Radius.circular(125)))),
              )),
          AnimatedPositioned(
              curve: Curves.easeInOutCubic,
              top: isFinished ? MediaQuery.of(context).size.height / 2 : -500,
              left: MediaQuery.of(context).size.width / 4,
              right: MediaQuery.of(context).size.width / 4,
              child: afterCarouselContainer(),
              duration: Duration(seconds: 1)),
          AnimatedPositioned(
              curve: Curves.easeInOutCubic,
              bottom: scannerState == CarouselState.Waiting ? 60 : -500,
              left: MediaQuery.of(context).size.width / 8,
              right: MediaQuery.of(context).size.width / 8,
              child: beginContainer(),
              duration: Duration(seconds: 1))
          //progressBar()
        ],
      ),
    );
  }

  Widget afterCarouselContainer() {
    return InkWell(
      onTap: () {
        setState(() {
          scannerState = CarouselState.Waiting;
          isFinished = false;
          showCarousel = false;
          playCarousel = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        height: 100,
        width: 500,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 6),
                    child: Text(
                      "Scan igen",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 36.0,
                          color: Color.fromRGBO(64, 51, 142, 1),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
          ],
        ),
      ),
    );
  }

  Widget beginContainer() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      height: 100,
      width: 500,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Text(
                    "Venligst scan din tommelfinger",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 36.0,
                        color: Color.fromRGBO(64, 51, 142, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(vertical: 8),
          ),
        ],
      ),
    );
  }

  Widget jobCard(String asset) {
    return Padding(
      child: Container(
          height: 300,
          width: 600,
          child: Image(image: AssetImage("Assets/$asset"), fit: BoxFit.cover)),
      padding: EdgeInsets.all(2),
    );
  }

  Widget progressBar() {
    return Padding(
      padding: EdgeInsets.only(top: 1000),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 600,
                child: LinearProgressIndicator(
                  minHeight: 20,
                  backgroundColor: Colors.red,
                  value: animationController.value,
                  color: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                )),
          ],
        ),
      ),
    );
  }

  showJobDialog() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 16.0),
            content: Container(
                width: 520.0,
                height: 520,
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 2, top: 26),
                                child: Text(
                                  "Dit nye job er",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 42.0,
                                      color: Color.fromRGBO(64, 51, 142, 1),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        Divider(
                          color: Color.fromRGBO(64, 51, 142, 1),
                          height: 6.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 16),
                          child: jobCard('youtuber.png'),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              showCarousel = false;
                            });
                            Navigator.pop(
                                context); // Closes alertdialog & navigates to choose booking type
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(64, 51, 142, 1),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(32.0),
                                  bottomRight: Radius.circular(32.0)),
                            ),
                            child: Text(
                              "Luk",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: -10,
                      right: 4,
                      child: Padding(
                        padding: EdgeInsets.only(right: 0),
                        child: IconButton(
                          icon: Icon(Icons.close,
                              color: Color.fromRGBO(64, 51, 142, 1), size: 30),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    )
                  ],
                )),
          );
        });
  }
}
