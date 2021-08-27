import 'dart:async';

import 'package:crushai/pieces/robot.dart';
import 'package:crushai/pieces/source.dart';
import 'package:crushai/pieces/start_line.dart';
import 'package:crushai/services/constants.dart';
import 'package:crushai/services/random_int_list.dart';
import 'package:crushai/timer/timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int crossAxisCount = 4;
  int sourcePosition = 0;
  int startPosition = -1;

  List<int> gridTiles = [];

  ValueNotifier<List<int>> barrierTiles = ValueNotifier<List<int>>([]);
  ValueNotifier<int> valuePosition = ValueNotifier<int>(0);

  bool tapPlaceSource = false;
  bool tapStartPosition = false;
  bool timerStarted = false;



  @override
  void initState() {
    gridTiles = List.generate(
        crossAxisCount * (crossAxisCount * 1.5).ceil(), (index) => index);
    valuePosition.addListener(() {
      if(tapPlaceSource){
        setSource();
      }
      if(tapStartPosition){
        setStartPosition();
      }
       });
    super.initState();
  }

  void setSource(){
    setState(() {
      sourcePosition = valuePosition.value;
    });
  }
  void placeSource() {

    setState(() {
      tapPlaceSource = !tapPlaceSource;
    });
  }
  void setStartPosition(){
    setState(() {
      startPosition = valuePosition.value;
    });
  }
  void placeStart() {
    setState(() {
      tapStartPosition = !tapStartPosition;
  });}

  void startTimer() {
    setState(() {
      timerStarted = !timerStarted;
    });
  }

  @override
  Widget build(BuildContext context) {

    print(gridTiles);
    double gridBoxHeight = ScreenUtil().screenWidth / crossAxisCount;
    int rowCount = (crossAxisCount * 1.5).ceil();
    int gridCount = crossAxisCount * rowCount;
    double screenHeight = gridBoxHeight * crossAxisCount * 2;
    print(RandomIntList().generateList(gridCount));

    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: screenHeight,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.blue,
                child: GestureDetector(
                  onVerticalDragStart: (DragStartDetails details) {
                    print(details);
                    // print(widget.indexKey);
                  },
                  onVerticalDragUpdate: (DragUpdateDetails details) {
                    print(details);
                    // print(widget.indexKey);
                  },
                  onVerticalDragEnd: (DragEndDetails details) {
                    print(details);
                    // print(widget.indexKey);
                  },
                  child: ValueListenableBuilder<int>(
                    valueListenable: valuePosition,
                    builder: (context,value,_) {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                        ),
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: gridCount,
                        itemBuilder: (context, index) {
                          if(sourcePosition == index){
                            return Source();
                          } else if(startPosition == index){
                            return Robot();
                          }else if(tapPlaceSource || tapStartPosition){
                            return AnimatedGridBox(indexKey: index,valuePosition: valuePosition,);
                          } else{
                            return AnimatedGridBox(indexKey: index,barrierTiles: barrierTiles,);
                          }
                        },
                      );
                    }
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.blue,
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: placeSource,
                      child: Column(
                        children: [
                          Text(
                            'Place',
                            style: TextStyle(color: Colors.black, fontSize: defaultFontSize),
                          ),
                          Text(
                            'Source',
                            style: TextStyle(color: Colors.black, fontSize: defaultFontSize),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: placeStart,
                      child: Column(
                        children: [
                          Text(
                            'Start',
                            style: TextStyle(color: Colors.black, fontSize: defaultFontSize),
                          ),
                          Text(
                            'Position',
                            style: TextStyle(color: Colors.black, fontSize: defaultFontSize),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !tapPlaceSource && !tapStartPosition,
                      child: GameTimer(),
                    ),
                    Visibility(
                      visible: !tapPlaceSource && !tapStartPosition,
                      child: GestureDetector(
                          child: Text(
                            'Restart ',
                            style: TextStyle(color: Colors.black, fontSize: defaultFontSize),
                          )),
                    ),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedGridBox extends StatefulWidget {
  final int indexKey;
  final ValueNotifier? valuePosition;
  final ValueNotifier<List<int>>? barrierTiles;

  const AnimatedGridBox({Key? key, required this.indexKey, this.valuePosition,this.barrierTiles}) : super(key: key);
  @override
  _AnimatedGridBoxState createState() => _AnimatedGridBoxState();
}

class _AnimatedGridBoxState extends State<AnimatedGridBox> {
  Color boxColor = Colors.grey.shade200;

  void changeColor() {
      if (boxColor == Colors.grey.shade200) {
        widget.barrierTiles?.value.add(widget.indexKey);
        setState(() {
          boxColor = Colors.red;
          print('Barrier Tiles: ${widget.barrierTiles?.value}');
        });
      } else {
        widget.barrierTiles?.value.remove(widget.indexKey);
        setState(() {
          print('Barrier Tiles: ${widget.barrierTiles?.value}');
          boxColor = Colors.grey.shade200;
        });
      }

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        changeColor();
        widget.valuePosition?.value = widget.indexKey;
      },
      child: AnimatedContainer(
        key: Key(widget.indexKey.toString()),
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
            color: boxColor, border: Border.all(color: Colors.red, width: 1)),
      ),
    );
  }
}
