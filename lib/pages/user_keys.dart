import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serrature/models/room_model.dart';
import 'package:serrature/utils/auth_gate.dart';
import 'package:serrature/models/booking_model.dart';
import 'package:serrature/utils/chiave.dart';
import 'package:serrature/utils/connection.dart';

class UserKeys extends StatefulWidget {
  @override
  _UserKeys createState() => _UserKeys();
}

class _UserKeys extends State<UserKeys> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Timer? timer;

  // void easy() {
  //   setState(() {});
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   executeOnMinute(easy);
  // }

  // void executeOnMinute(void Function() callback) {
  //   var now = DateTime.now();
  //   var nextMinute =
  //       DateTime(now.year, now.month, now.day, now.hour, now.minute + 1);
  //   Timer(nextMinute.difference(now), () {
  //     Timer.periodic(const Duration(minutes: 1), (timer) {
  //       callback();
  //     });

  //     // Execute the callback on the first minute after the initial time.
  //     //
  //     // This should be done *after* registering the periodic [Timer] so that it
  //     // is unaffected by how long [callback] takes to execute.
  //     callback();
  //   });
  // }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    new Timer.periodic(Duration(seconds: 5), (Timer t) => setState(() {}));
  }

  Socket? socket;
  bool open = true;
  bool available = true;

  void apri(pos) {
    Socket? socket;
    Socket.connect("192.168.2.99", 5000).then((Socket sock) {
      socket = sock;
      var start = 0x02;
      var finish = 0x03;
      var cmd = 0x31;
      var message = Uint8List(5);
      var bytedata = ByteData.view(message.buffer);
      var len = start + finish + cmd + pos;

      bytedata.setUint8(0, start);
      bytedata.setUint8(1, pos);
      bytedata.setUint8(2, cmd);
      bytedata.setUint8(3, finish);
      bytedata.setUint8(4, len.toInt());

      socket?.add(message);
      socket?.listen(dataHandler,
          onError: errorHandler, onDone: doneHandler, cancelOnError: false);
      socket?.close();
      socket?.destroy();
      socket = null;
    }).catchError((Object e) {
      print("Unable to connect: $e");
    });
    //Connect standard in to the socket
    stdin.listen(
        (data) => socket?.write(new String.fromCharCodes(data).trim() + '\n'));
  }

  void dataHandler(data) {
    print(new String.fromCharCodes(data).trim());
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket?.close();
    socket?.destroy();
    socket = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          title: Text("Key bookings"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {});
              },
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                // .collection('users')
                // .doc(uid)
                //.collection('booking')
                //.where("finish",
                //  isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime.now()))
                .collection('booking')
                .where("user_uid", isEqualTo: uid)
                .snapshots(),
            builder: (
              context,
              snapshot,
            ) {
              if (snapshot.hasData) {
                return Container(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var start = snapshot.data!.docs[index]['start'];
                      var finish = snapshot.data!.docs[index]['finish'];
                      //var user_uid = snapshot.data!.docs[index]['user_uid'];
                      var ora = Timestamp.fromDate(DateTime.now());
                      Booking booking =
                          Booking.fromSnap(snapshot.data!.docs[index]);
                      if ((start.compareTo(ora) <= 0) /*&& user_uid == uid*/ &&
                          (finish.compareTo(ora) > 0)) {
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                leading: ElevatedButton.icon(
                                  icon: Icon(Icons.key_rounded),
                                  label: Text('Open'),
                                  onPressed: () => {
                                    apri(booking.room_code)
                                    //  snapshot.data!.docs[index]['room_code'])
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => Chiave(),
                                    //   ),
                                    // )
                                    //Connection(0x03, 0x31).lancia(),
                                  },
                                ),
                                title: Text("${booking.room_name}"),
                                // title: Text(
                                //     "${snapshot.data!.docs[index]['room_name']}"),
                                subtitle:
                                    Text("Room Number ${booking.room_number}"),
                              ),
                              // ListTile(
                              //   title: Text(
                              //       "Room Number ${snapshot.data!.docs[index]['room_number']}"),
                              // ),
                              //   ElevatedButton.icon(
                              //     icon: Icon(Icons.key_rounded),
                              //     label: Text('Open'),
                              //     onPressed: () => {
                              //       //apri(snapshot.data!.docs[index]['code_room'])
                              //       // Navigator.push(
                              //       //   context,
                              //       //   MaterialPageRoute(
                              //       //     builder: (context) => Chiave(),
                              //       //   ),
                              //       // )
                              //       Connection(0x03, 0x31).lancia(),
                              //     },
                              // ),
                            ],
                          ),
                        );
                      } else {
                        return Text("");
                      }
                    },
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.red,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                ),
              );
            }));
  }
}
