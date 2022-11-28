import 'package:e4link_flutter/models.dart';
import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  E4Device device;
  ExerciseTile({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Student Name',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text("ID: ${this.device.id}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 14,
                )),
            SizedBox(
              width: 5,
            ),
            Text("Heart Rate: ${this.device.readings["hr"]}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 14,
                )),
            SizedBox(
              width: 5,
            ),
            Text(
                "Skin Temperature: ${this.device.readings["tmp"].toStringAsFixed(1)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 14,
                )),
            SizedBox(
              width: 5,
            ),
            Text("GSR: ${this.device.readings["gsr"]}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 14,
                )),
            SizedBox(
              width: 5,
            ),
            Text("new: ${this.device.readings["cal"]}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  fontSize: 14,
                )),
          ],
        )
      ],
    );
  }
}
