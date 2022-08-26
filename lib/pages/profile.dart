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

class Profile extends StatefulWidget {
  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  void elimina(String id) {
    try {
      FirebaseFirestore.instance.collection('booking').doc(id)..delete();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          title: Text("Bookings Made"),
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
                  keys.add(booking);
                }
                keys.sort((a, b) => b.start.compareTo(a.start));
                return Container(
                  child: ListView.builder(
                    itemCount: keys.length,
                    itemBuilder: (context, index) {
                      var start = keys[index].start;
                      var finish = keys[index].finish;
                      var ora = DateTime.now();
                      //Booking booking =
                      //  Booking.fromSnap(snapshot.data!.docs[index]);
                      if (((start.compareTo(ora) >= 0) &&
                              (finish.compareTo(ora) < 0)) ||
                          (finish.compareTo(ora) > 0)) {
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                leading: ElevatedButton.icon(
                                  icon: Icon(Icons.delete),
                                  label: Text('Delete'),
                                  onPressed: () => {elimina(keys[index].id)},
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.red,
                                  ),
                                ),
                                title: Text("${keys[index].room_name}"),
                                subtitle: Text(
                                    "Room Number = ${keys[index].room_number} \nStart = ${DateFormat('dd/MM/yyyy  HH:mm').format(keys[index].start)} \nFinish Time = ${DateFormat('dd/MM/yyyy  HH:mm').format(keys[index].finish)}"),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              ListTile(
                                title: Text("${keys[index].room_name}"),
                                subtitle: Text(
                                    "Room Number = ${keys[index].room_number} \nStart = ${DateFormat('dd/MM/yyyy  HH:mm').format(keys[index].start)} \nFinish Time = ${DateFormat('dd/MM/yyyy  HH:mm').format(keys[index].finish)}"),
                              ),
                            ],
                          ),
                        );
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
