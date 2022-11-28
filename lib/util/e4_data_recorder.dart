import 'dart:io';

import 'package:e4link_flutter/models.dart';

class E4DataRecorder {
  late String sessionName;
  Map<String, IOSink> fileSinks = {};
  E4DataRecorder(id) {
    sessionName = id;
    fileSinks["hr"] = File("${id}_hr.csv").openWrite();
    fileSinks["tmp"] = File("${id}_tmp.csv").openWrite();
    fileSinks["gsr"] = File("${id}_gsr.csv").openWrite();
  }

  void addRecord(E4Event e4event) {
    fileSinks[e4event.dataType.value]
        ?.write("${e4event.timestamp},${e4event.value}\n");
  }

  void endSession() {
    fileSinks["hr"]?.close();
    fileSinks["tmp"]?.close();
    fileSinks["gsr"]?.close();
  }
}
