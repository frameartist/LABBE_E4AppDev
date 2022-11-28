import 'package:e4link_flutter/e4link_flutter.dart';
import 'package:e4link_flutter/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/student_list.dart';
import 'package:flutter_application_1/util/e4_data_recorder.dart';
import 'package:flutter_application_1/util/emoticon_face.dart';
import 'package:flutter_application_1/ui/exercise_tile.dart';
import 'package:flutter_application_1/util/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  int ideal_number = 10;
  int ideal_number_2 = 15;
  PageController pageController = PageController();
  Map<String, E4Device> devices = {};
  Map<String, E4DataRecorder> recorders = {};

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.animateToPage(index,
        duration: Duration(milliseconds: 10), curve: Curves.easeIn);
  }

  @override
  void initState() {
    super.initState();
    initE4Connecton();
  }

  void dispose() {
    super.dispose();
    for (E4DataRecorder recorder in recorders.values) {
      recorder.endSession();
    }
  }

  Future<void> initE4Connecton() async {
    var discoveredDevices = await E4linkFlutter.discoverDevices();
    for (var device in discoveredDevices) {
      setState(() {
        devices[device.id] = device;
        recorders[device.id] = E4DataRecorder(device.id);
      });
      E4linkFlutter.connect(device.id);
    }
    E4linkFlutter.eventStream.listen(handleE4Events);
  }

  void handleE4Events(E4Event event) async {
    switch (event.dataType) {
      case E4EventType.hr:
        {
          setState(() {
            devices[event.id]?.readings[event.dataType.value] = event.value;
          });
        }
        break;
      case E4EventType.bvp:
      case E4EventType.tmp:
      case E4EventType.gsr:
        {
          setState(() {
            devices[event.id]?.readings[event.dataType.value] = event.value;
            devices[event.id]?.readings["cal"] =
                devices[event.id]?.readings["hr"] *
                    devices[event.id]?.readings["tmp"];
            recorders[event.id]?.addRecord(event);
          });
        }
        break;
      case E4EventType.connected:
        {
          await E4linkFlutter.subscribe(event.id, "ibi");
          await E4linkFlutter.subscribe(event.id, "tmp");
          await E4linkFlutter.subscribe(event.id, "gsr");
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          Container(
            color: Colors.blue[900],
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Hi Jared
                        Text(
                          'Teacher Mode',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                  /*SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'How is the student feeling?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.more_horiz,
              color: Colors.white,
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          //emoticons
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
            //bad
            EmoticonFace(emoticonFace: '☹️',
            ),
            //cry
            EmoticonFace(emoticonFace: '😢',
            ),
            //confused
            EmoticonFace(emoticonFace: '🫤',
            ),
            //excellent
            EmoticonFace(emoticonFace: '😊',
            )
          ],
          ),*/
                  SizedBox(
                    height: 25,
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(25),
                      color: Colors.grey[400],
                      child: Center(
                        child: StudentList(devices: devices),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.blue[100],
            child: SafeArea(
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    //Hi Jared
                    Text(
                      'Heart Rate Details',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Student 1',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(
                    value: 5 / ideal_number, //change to variables input/ideal
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Heart Rate: '),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Student 2',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(
                    value: 5 / ideal_number_2, //change to variables input/ideal
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Heart Rate: '),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Student 3',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(
                    value: 5 / ideal_number_2, //change to variables input/ideal
                  ),
                  Text('Heart Rate: '),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Student 4',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(
                    value: 5 / ideal_number_2, //change to variables input/ideal
                  ),
                  Text('Heart Rate: '),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.blue[100],
            child: SafeArea(
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    //Hi Jared
                    Text(
                      'Skin Temperature Details',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Student 1',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(
                    value: 5 / ideal_number, //change to variables input/ideal
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Skin Temperature: '),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Student 2',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(
                    value: 5 / ideal_number_2, //change to variables input/ideal
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Skin Temperature: '),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Student 3',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(
                    value: 5 / ideal_number_2, //change to variables input/ideal
                  ),
                  Text('Skin Temperature: '),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Student 4',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(
                    value: 5 / ideal_number_2, //change to variables input/ideal
                  ),
                  Text('Skin Temperature: '),
                ],
              ),
            ),
          ),
          /*Container(
            color: Colors.blue[100],
            child: Column(
              children: <Widget> [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('/Users/apple/Desktop/EP4/flutter_application_1/download.jpeg'),
                ),
                Text("Sam Smith"),
                 SizedBox(
                  height: 15,
                ),
                Text("Contact Number: 852 12345678"),
                 SizedBox(
                  height: 15,
                ),
                Text("Address: United College"),
                
              ],)
            )*/
          Container(
            color: Colors.blue[100],
            child: SafeArea(
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    //Hi Jared
                    Text(
                      'Pulse Rate Details',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Student 1',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(
                    value: 5 / ideal_number, //change to variables input/ideal
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Pulse Rate: '),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Student 2',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(
                    value: 5 / ideal_number_2, //change to variables input/ideal
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Pulse Rate: '),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Student 3',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(
                    value: 5 / ideal_number_2, //change to variables input/ideal
                  ),
                  Text('Pulse Rate: '),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Student 4',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  CircularProgressIndicator(
                    value: 5 / ideal_number_2, //change to variables input/ideal
                  ),
                  Text('Pulse Rate: '),
                ],
              ),
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_outline), label: 'Heart Rate'),
            BottomNavigationBarItem(
                icon: Icon(Icons.health_and_safety), label: 'Skin Temperature'),
            BottomNavigationBarItem(
                icon: Icon(Icons.medical_information), label: 'Pulses')
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.grey[400],
          unselectedItemColor: Colors.blue[900],
          onTap: onTapped),
    );
  }
}
