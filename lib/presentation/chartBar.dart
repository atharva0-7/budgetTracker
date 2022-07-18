import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ChartBar extends StatelessWidget {
  String label;
  String amount;
  ChartBar(this.label, this.amount);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FittedBox(
            child: Text(
          "Rs " + amount,
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        Container(
          decoration: BoxDecoration(
              color: Colors.purple, borderRadius: BorderRadius.circular(5)),
          height: 60,
          width: 15,
          // color: Colors.blue,
        ),
        SizedBox(width: 30),
        Text(label)
      ],
    );
  }
}
