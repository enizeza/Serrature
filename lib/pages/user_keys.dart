import 'dart:async';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:serrature/models/command_model.dart';
import 'package:serrature/models/room_model.dart';
import 'package:serrature/utils/auth_gate.dart';
import 'package:serrature/models/booking_model.dart';

class UserKeys extends StatefulWidget {
  @override
  _UserKeys createState() => _UserKeys();
}

class _UserKeys extends State<UserKeys> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    new Timer.periodic(Duration(seconds: 5), (Timer t) => setState(() {}));
  }

  void apri(String pos) {
    var start = 0x02;
    var finish = 0x03;
    var cmd = 0x31;
    var message = Uint8List(5);
    var bytedata = ByteData.view(message.buffer);
    var len = start + finish + cmd + int.parse(pos);

    bytedata.setUint8(0, start);
    bytedata.setUint8(1, int.parse(pos));
    bytedata.setUint8(2, cmd);
    bytedata.setUint8(3, finish);
    bytedata.setUint8(4, len.toInt());

    String id = FirebaseFirestore.instance.collection('command').doc().id;
    try {
      Command command = Command(
        cmd: "0x31",
        done: false,
        id: id,
        len: len.toString(),
        pos: pos,
        response: "",
        user: uid,
      );
      FirebaseFirestore.instance
          .collection('command')
          .doc(id)
          .set(command.toJson());
    } catch (e) {}
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
                .collection('booking')
                .where("user_uid", isEqualTo: uid)
                .snapshots(),
            builder: (
              context,
              snapshot,
            ) {
              if (snapshot.hasData) {
                List<Booking> keys = [];
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  Booking booking = Booking.fromSnap(snapshot.data!.docs[i]);
                  var start = snapshot.data!.docs[i]['start'];
                  var finish = snapshot.data!.docs[i]['finish'];
                  var ora = Timestamp.fromDate(DateTime.now());
                  if ((start.compareTo(ora) <= 0) &&
                      (finish.compareTo(ora) > 0)) {
                    keys.add(booking);
                  }
                }
                return Container(
                  child: ListView.builder(
                    itemCount: keys.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            ListTile(
                              leading: ElevatedButton.icon(
                                icon: Icon(Icons.key_rounded),
                                label: Text('Open'),
                                onPressed: () => {apri(keys[index].room_code)},
                              ),
                              title: Text("${keys[index].room_name}"),
                              subtitle: Text(
                                  "Room Number = ${keys[index].room_number} \nFinish Time = ${DateFormat('hh:mm').format(keys[index].finish)}"),
                            ),
                          ],
                        ),
                      );
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
