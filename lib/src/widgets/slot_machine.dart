import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_coding_challenge/src/widgets/lock_switch.dart';

class SlotMachine extends StatefulWidget {
  final double maxWidth;
  final int numReels;
  final List<List> reelsContent;
  final dynamic Function() onSpinStart;
  final Function(List<dynamic>) onSpinEnd;

  SlotMachine({
    Key key,
    @required this.maxWidth,
    @required this.reelsContent,
    @required this.onSpinStart,
    @required this.onSpinEnd,
  })  : numReels = reelsContent.length,
        super(key: key);

  @override
  _SlotMachineState createState() => _SlotMachineState();
}

class _SlotMachineState extends State<SlotMachine> {
  List<FixedExtentScrollController> _scrollControllers;
  List<bool> _isReelLocked;
  bool _isSpinning;

  @override
  initState() {
    _isSpinning = false;
    super.initState();
    _scrollControllers = List.generate(
      widget.numReels,
      (_) => FixedExtentScrollController(),
    );
    _isReelLocked = List<bool>.generate(
      widget.numReels,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = (widget.maxWidth - 32) / widget.numReels;
    return Column(
      key: Key('slotMachine'),
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(
              color: Colors.black26,
              width: 10,
            ),
          ),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.1, 0.2, 0.8, 0.9],
                    colors: [
                      Colors.black38,
                      Colors.white24,
                      Colors.white24,
                      Colors.black38
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(widget.numReels,
                      (i) => buildSlot(i, width, _scrollControllers[i])),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.5, 0.5],
                    colors: [
                      Colors.blueAccent.withOpacity(0.2),
                      Colors.blueGrey.withOpacity(0.5),
                    ],
                  ),
                ),
                height: 50,
              ),
            ],
          ),
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            widget.numReels,
            (i) => LockSwitch(
              onChanged:
                  _isSpinning ? null : (value) => _isReelLocked[i] = value,
            ),
          ),
        ),
        Spacer(
          flex: 5,
        ),
        ButtonTheme(
          minWidth: 300,
          height: 60,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30))),
            color: Color.fromRGBO(255, 220, 100, 1),
            child: Text(
              "SPIN!",
              style: TextStyle(fontSize: 25),
            ),
            onPressed: _isSpinning
                ? null
                : () {
                    spinMachine();
                  },
          ),
        ),
        Spacer(
          flex: 6,
        ),
      ],
    );
  }

  Container buildSlot(
      int reelIndex, double width, ScrollController controller) {
    final content = widget.reelsContent[reelIndex];
    final count = content.length;
    return Container(
      decoration: BoxDecoration(border: Border.all()),
      width: width,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 100,
        physics: FixedExtentScrollPhysics(),
        diameterRatio: 1.5,
        perspective: 0.005,
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) => Center(
              child: Text(
            content[index % count].toString(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
      ),
    );
  }

  Future<void> spinMachine() async {
    setState(() {
      _isSpinning = true;
    });
    var randomStops = List.generate(widget.numReels,
        (i) => Random().nextInt(widget.reelsContent[i].length));

    for (var i = -40; i < 0; i++) {
      var tasks = List<Future>();
      for (var c = 0; c < _scrollControllers.length; c++) {
        if (!_isReelLocked[c]) {
          tasks.add(
            _scrollControllers[c].animateToItem(
              randomStops[c] + i,
              duration: Duration(milliseconds: 150),
              curve: Curves.linear,
            ),
          );
        }
      }
      await Future.wait(tasks);
    }
    var tasks = List<Future>();
    for (var c = 0; c < _scrollControllers.length; c++) {
      if (!_isReelLocked[c]) {
        tasks.add(
          _scrollControllers[c].animateToItem(
            randomStops[c],
            duration: Duration(seconds: 1),
            curve: Curves.bounceOut,
          ),
        );
      } else {
        randomStops[c] =
            _scrollControllers[c].selectedItem % widget.reelsContent[c].length;
      }
    }
    await Future.wait(tasks);
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isSpinning = false;
    });

    var result = [];
    for (int i = 0; i < widget.numReels; i++) {
      result.add(widget.reelsContent[i][randomStops[i]]);
    }
    widget.onSpinEnd(result);
  }
}
