import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Booking extends StatefulWidget {
  static const pathName = '/booking';

  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  // bool _loaded = false;
  String dropdownValue = 'Tomorrow';
  int selectedTime = 0;

  @override
  void initState() {
    // Future.delayed(Duration(milliseconds: 250), () {
    //   setState(() {
    //     this._loaded = true;
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (this._loaded) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: 0.05 * MediaQuery.of(context).size.width,
            vertical: 20.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: Colors.white,
                  width: constraints.maxWidth,
                  height: 0.3 * constraints.maxHeight,
                ),
                Container(
                  width: constraints.maxWidth,
                  height: 0.4 * constraints.maxHeight,
                  child: SeatsGrid(),
                ),
                Container(
                  width: constraints.maxWidth,
                  height: 0.25 * constraints.maxHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SeatIndicatorsRow(),
                      Row(
                        children: [
                          DayPicker(
                            dropdownValue: dropdownValue,
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                              });
                            },
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        this.selectedTime = 0;
                                      });
                                    },
                                    child: TimeMenuItem(
                                      text: '17.30',
                                      background: this.selectedTime == 0
                                          ? Colors.red
                                          : Colors.transparent,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        this.selectedTime = 1;
                                      });
                                    },
                                    child: TimeMenuItem(
                                      text: '18.00',
                                      background: this.selectedTime == 1
                                          ? Colors.red
                                          : Colors.transparent,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        this.selectedTime = 2;
                                      });
                                    },
                                    child: TimeMenuItem(
                                      text: '20.40',
                                      background: this.selectedTime == 2
                                          ? Colors.red
                                          : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      PayButton(
                        width: constraints.maxWidth,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
    // } else {
    //   return Container();
    // }
  }
}

class PayButton extends StatelessWidget {
  const PayButton({
    Key key,
    this.width,
  }) : super(key: key);
  final double width;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.red,
      minWidth: width,
      height: 50.0,
      child: Text(
        'PAY',
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12.0),
      ),
      onPressed: () {},
    );
  }
}

class TimeMenuItem extends StatelessWidget {
  const TimeMenuItem({
    Key key,
    @required this.text,
    this.background,
  }) : super(key: key);
  final String text;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 15.0),
      padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 15.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[800]),
        borderRadius: BorderRadius.circular(5.0),
        color: background,
      ),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 12.0),
      ),
    );
  }
}

class DayPicker extends StatelessWidget {
  const DayPicker({
    Key key,
    @required this.dropdownValue,
    @required this.onChanged,
  }) : super(key: key);

  final String dropdownValue;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        value: dropdownValue,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        iconEnabledColor: Colors.grey[200],
        dropdownColor: Colors.black87,
        style: TextStyle(color: Colors.grey[200]),
        underline: Container(height: 0.0),
        items: <String>['Yesterday', 'Today', 'Tomorrow']
            .map<DropdownMenuItem<String>>((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: onChanged);
  }
}

class SeatIndicatorsRow extends StatelessWidget {
  const SeatIndicatorsRow({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SeatIndicator(
          color: Colors.white,
          text: 'Available',
        ),
        SeatIndicator(
          color: Colors.grey[700],
          text: 'Taken',
        ),
        SeatIndicator(
          color: Colors.red,
          text: 'Selected',
        ),
      ],
    );
  }
}

class SeatIndicator extends StatelessWidget {
  final Color color;
  final String text;
  const SeatIndicator({Key key, this.color, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          height: 10.0,
          width: 10.0,
        ),
        SizedBox(width: 10.0),
        Text(
          text,
          style: TextStyle(
              color: Colors.white, fontSize: 12.0, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

class SeatsGrid extends StatefulWidget {
  const SeatsGrid({
    Key key,
  }) : super(key: key);

  @override
  _SeatsGridState createState() => _SeatsGridState();
}

class _SeatsGridState extends State<SeatsGrid> {
  List<List> _selectedSeats = [];

  bool isSelected(List position) {
    for (int x = 0; x < this._selectedSeats.length; x++) {
      if (listEquals(this._selectedSeats[x], position)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (int i = 0; i < 10; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int j = 0; j < 10; j++)
                  GestureDetector(
                    onTapDown: (details) {
                      setState(() {
                        if (this.isSelected([i, j])) {
                          this
                              ._selectedSeats
                              .removeWhere((item) => listEquals(item, [i, j]));
                        } else {
                          this._selectedSeats.add([i, j]);
                        }
                      });
                    },
                    onPanUpdate: (details) {
                      print([i, j]);
                    },
                    child: Container(
                      height: constraints.maxHeight / 10,
                      width: constraints.maxWidth / 10,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: this.isSelected([i, j])
                                ? Colors.red
                                : Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              topRight: Radius.circular(5.0),
                            ),
                          ),
                          height: 20.0,
                          width: 20.0,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
        ],
      );
    });
  }
}
