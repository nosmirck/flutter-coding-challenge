import 'package:flutter/material.dart';

class LockSwitch extends StatefulWidget {
  @required
  final bool value;
  @required
  final Function(bool) onChanged;
  final IconData iconOn;
  final IconData iconOff;
  LockSwitch(
      {Key key,
      this.value = false,
      this.iconOff = Icons.lock_open,
      this.iconOn = Icons.lock_outline,
      this.onChanged})
      : super(key: key);

  @override
  _LockSwitchState createState() => _LockSwitchState();
}

class _LockSwitchState extends State<LockSwitch> {
  bool _value;
  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 150),
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: Container(
        key: Key(_value.toString()),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: _value
              ? RadialGradient(colors: [
                  Colors.yellowAccent.withOpacity(0.5),
                  Colors.yellowAccent.withOpacity(0.0),
                ])
              : null,
        ),
        child: IconButton(
          iconSize: 50,
          icon: Icon(
            _value ? widget.iconOn : widget.iconOff,
            color: Colors.white70,
            size: 50,
          ),
          onPressed: () => setState(() {
            _value = !_value;
            widget.onChanged(_value);
          }),
        ),
      ),
    );
  }
}
