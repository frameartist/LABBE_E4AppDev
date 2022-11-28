import 'package:e4link_flutter/models.dart';
import 'package:flutter/material.dart';

import 'exercise_tile.dart';

class StudentList extends StatelessWidget {
  Map<String, E4Device> devices;
  StudentList({Key? key, required this.devices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView.builder(
        itemBuilder: (context, index) {
          return Column(children: [
            Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.favorite),
                    SizedBox(
                      width: 12,
                    ),
                    ExerciseTile(device: devices.entries.toList()[index].value),
                  ],
                )),
            SizedBox(
              height: 15,
            )
          ]);
        },
        itemCount: devices.length);
  }
}
