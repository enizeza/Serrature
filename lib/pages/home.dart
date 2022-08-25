import 'package:serrature/models/room_model.dart';
import 'package:serrature/widgets/app_bottom_navigation.dart';
import 'package:serrature/widgets/room_card.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightFromWhiteBg = size.height - 200.0;
    return Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(
          title: Text("Rooms dashboard"),
        ),
        bottomNavigationBar: AppBottomNavigation(),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('room').snapshots(),
            builder: (
              context,
              snapshot,
            ) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SafeArea(child: SizedBox()),
                        SizedBox(
                          height: 15.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                        ),
                        Container(
                          height: heightFromWhiteBg,
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              Room room =
                                  Room.fromSnap(snapshot.data!.docs[index]);
                              return RoomCard(
                                room: room,
                              );
                            },
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(
                                width: 10.0,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
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
