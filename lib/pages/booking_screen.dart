import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:serrature/booking_details.dart';
// import 'package:doors/widgets/booking_property_features.dart';
// import 'package:doors/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:serrature/models/room_model.dart';
import 'package:serrature/utils/time_slot.dart';
//import 'package:flutter_icons/flutter_icons.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:serrature/utils/auth_gate.dart';
import 'package:serrature/models/booking_model.dart';
import 'package:serrature/utils/chiave.dart';
import 'package:serrature/utils/connection.dart';

class BookingScreen extends StatefulWidget {
  final Room room;
  const BookingScreen({required this.room});

  @override
  _BookingScreen createState() => _BookingScreen();
}

class _BookingScreen extends State<BookingScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  var now = DateTime.now();
  bool time = false;
  var slot_time;

  void selected_date(DateTime data) {
    setState(() {
      now = data;
    });
  }

  void selected_time(var dato) {
    setState(() {
      time = true;
      slot_time = dato;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightFromWhiteBg = size.height - 200.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Select dates"),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('booking')
              .where("room_code", isEqualTo: widget.room.room_code)
              .snapshots(),
          builder: (
            context,
            snapshot,
          ) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: heightFromWhiteBg,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Center(
                                    child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                children: [
                                  Text(
                                    '${DateFormat.MMMM().format(now)}',
                                    style: GoogleFonts.robotoMono(
                                        color: Colors.white),
                                  ),
                                  Text(
                                    '${now.day}',
                                    style: GoogleFonts.robotoMono(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${DateFormat.EEEE().format(now)}',
                                    style: GoogleFonts.robotoMono(
                                      color: Colors.white,
                                    ),
                                  ),
                                  Container(
                                    child: TextButton(
                                      child: Icon(
                                        Icons.calendar_today,
                                      ),
                                      onPressed: () {
                                        DatePicker.showDatePicker(context,
                                            showTitleActions: true,
                                            minTime: now,
                                            maxTime:
                                                now.add(Duration(days: 365)),
                                            onConfirm: (date) =>
                                                selected_date(date));
                                      },
                                    ),
                                  ),
                                  // ElevatedButton.icon(
                                  //   // Icons.calendar_today,
                                  //   // color: Colors.white,
                                  //   onPressed: () {
                                  //     DatePicker.showDatePicker(context,
                                  //         showTitleActions: true,
                                  //         minTime: now,
                                  //         maxTime: now.add(Duration(days: 365)));
                                  //   },
                                  //   icon: Icon(Icons.calendar_today),
                                  //   label: null,
                                  //   //size: 70,
                                  // )
                                  // Expanded(
                                  //     child: GridView.builder(
                                  //         itemCount: TIME_SLOT.length,
                                  //         //itemCount: snapshot.data!.docs.length,
                                  //         gridDelegate:
                                  //             SliverGridDelegateWithFixedCrossAxisCount(
                                  //                 crossAxisCount: 3),
                                  //         itemBuilder: ((context, index) {
                                  //           var start = snapshot
                                  //               .data!.docs[index]["start"];
                                  //           DateTime start_dt = start.toDate();

                                  //           var finish = snapshot
                                  //               .data!.docs[index]["finish"];
                                  //           DateTime finish_dt =
                                  //               finish.toDate();

                                  //           var tempi = TIME_SLOT
                                  //               .elementAt(index)
                                  //               .split('-');
                                  //           var slot_inizio = tempi[0];
                                  //           var slot_fine = tempi[1];

                                  //           String tempo_start_book_db =
                                  //               // start_dt.hour.toString() +
                                  //               //     ":" +
                                  //               //     start_dt.minute.toString();
                                  //               DateFormat.Hm()
                                  //                   .format(start_dt);
                                  //           String tempo_finish_book_db =
                                  //               DateFormat.Hm()
                                  //                   .format(finish_dt);

                                  //           if (start_dt.year == now.year &&
                                  //               start_dt.month == now.month &&
                                  //               start_dt.day == now.day &&
                                  //               tempo_start_book_db.compareTo(
                                  //                       slot_inizio) <
                                  //                   0 &&
                                  //               tempo_finish_book_db
                                  //                       .compareTo(slot_fine) >
                                  //                   0) {
                                  //             return GestureDetector(
                                  //                 onTap: () {
                                  //                   // selected_time(TIME_SLOT
                                  //                   //     .elementAt(index));
                                  //                 },
                                  //                 child: Card(
                                  //                   // color: slot_time ==
                                  //                   //         TIME_SLOT
                                  //                   //             .elementAt(index)
                                  //                   //     ? Colors.white54
                                  //                   //     : Colors.white,
                                  //                   color: Colors.white54,
                                  //                   child: GridTile(
                                  //                     child: Center(
                                  //                       child: Column(
                                  //                         crossAxisAlignment:
                                  //                             CrossAxisAlignment
                                  //                                 .center,
                                  //                         mainAxisAlignment:
                                  //                             MainAxisAlignment
                                  //                                 .center,
                                  //                         children: [
                                  //                           Text(
                                  //                               '${TIME_SLOT.elementAt(index)}'),
                                  //                           //Text('Available')
                                  //                           Text(
                                  //                               'Not Available')
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                     // header: slot_time ==
                                  //                     //         TIME_SLOT.elementAt(index)
                                  //                     //     ? Icon(Icons.check)
                                  //                     //     : null,
                                  //                   ),
                                  //                 ));
                                  //           } else {
                                  //             return GestureDetector(
                                  //                 onTap: () {
                                  //                   selected_time(TIME_SLOT
                                  //                       .elementAt(index));
                                  //                 },
                                  //                 child: Card(
                                  //                   // color: slot_time ==
                                  //                   //         TIME_SLOT
                                  //                   //             .elementAt(index)
                                  //                   //     ? Colors.white54
                                  //                   //     : Colors.white,
                                  //                   color: Colors.white,
                                  //                   child: GridTile(
                                  //                     child: Center(
                                  //                       child: Column(
                                  //                         crossAxisAlignment:
                                  //                             CrossAxisAlignment
                                  //                                 .center,
                                  //                         mainAxisAlignment:
                                  //                             MainAxisAlignment
                                  //                                 .center,
                                  //                         children: [
                                  //                           Text(
                                  //                               '${TIME_SLOT.elementAt(index)}'),
                                  //                           Text('Available')
                                  //                           //Text('Not Available')
                                  //                         ],
                                  //                       ),
                                  //                     ),
                                  //                     // header: slot_time ==
                                  //                     //         TIME_SLOT.elementAt(index)
                                  //                     //     ? Icon(Icons.check)
                                  //                     //     : null,
                                  //                   ),
                                  //                 ));
                                  //           }
                                  //         })))

                                  Expanded(
                                      child: GridView.builder(
                                          itemCount: TIME_SLOT.length,
                                          //itemCount: snapshot.data!.docs.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3),
                                          itemBuilder: ((context, index) {
                                            if (snapshot.data != null) {
                                              int i = 0;
                                              while (i !=
                                                  snapshot.data!.docs.length -
                                                      1) {
                                                var start = snapshot
                                                    .data!.docs[index]["start"];
                                                DateTime start_dt =
                                                    start.toDate();

                                                var finish = snapshot.data!
                                                    .docs[index]["finish"];
                                                DateTime finish_dt =
                                                    finish.toDate();

                                                var tempi = TIME_SLOT
                                                    .elementAt(index)
                                                    .split('-');
                                                var slot_inizio = tempi[0];
                                                var slot_fine = tempi[1];

                                                String tempo_start_book_db =
                                                    DateFormat.Hm()
                                                        .format(start_dt);
                                                String tempo_finish_book_db =
                                                    DateFormat.Hm()
                                                        .format(finish_dt);
                                                if (start_dt.year == now.year &&
                                                    start_dt.month ==
                                                        now.month &&
                                                    start_dt.day == now.day &&
                                                    tempo_start_book_db
                                                            .compareTo(
                                                                slot_inizio) <
                                                        0 &&
                                                    tempo_finish_book_db
                                                            .compareTo(
                                                                slot_fine) >
                                                        0) {
                                                  return GestureDetector(
                                                      onTap: () {
                                                        // selected_time(TIME_SLOT
                                                        //     .elementAt(index));
                                                      },
                                                      child: Card(
                                                        // color: slot_time ==
                                                        //         TIME_SLOT
                                                        //             .elementAt(index)
                                                        //     ? Colors.white54
                                                        //     : Colors.white,
                                                        color: Colors.white54,
                                                        child: GridTile(
                                                          child: Center(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    '${TIME_SLOT.elementAt(index)}'),
                                                                //Text('Available')
                                                                Text(
                                                                    'Not Available')
                                                              ],
                                                            ),
                                                          ),
                                                          // header: slot_time ==
                                                          //         TIME_SLOT.elementAt(index)
                                                          //     ? Icon(Icons.check)
                                                          //     : null,
                                                        ),
                                                      ));
                                                } else {
                                                  return GestureDetector(
                                                      onTap: () {
                                                        selected_time(TIME_SLOT
                                                            .elementAt(index));
                                                      },
                                                      child: Card(
                                                        color: slot_time ==
                                                                TIME_SLOT
                                                                    .elementAt(
                                                                        index)
                                                            ? Colors.white54
                                                            : Colors.white,
                                                        child: GridTile(
                                                          child: Center(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                    '${TIME_SLOT.elementAt(index)}'),
                                                                Text(
                                                                    'Available')
                                                                //Text('Not Available')
                                                              ],
                                                            ),
                                                          ),
                                                          // header: slot_time ==
                                                          //         TIME_SLOT.elementAt(index)
                                                          //     ? Icon(Icons.check)
                                                          //     : null,
                                                        ),
                                                      ));
                                                }
                                              }
                                              i++;
                                            }
                                            return GestureDetector(
                                                onTap: () {
                                                  selected_time(TIME_SLOT
                                                      .elementAt(index));
                                                },
                                                child: Card(
                                                  color: slot_time ==
                                                          TIME_SLOT
                                                              .elementAt(index)
                                                      ? Colors.white54
                                                      : Colors.white,
                                                  child: GridTile(
                                                    child: Center(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                              '${TIME_SLOT.elementAt(index)}'),
                                                          Text('Available')
                                                          //Text('Not Available')
                                                        ],
                                                      ),
                                                    ),
                                                    // header: slot_time ==
                                                    //         TIME_SLOT.elementAt(index)
                                                    //     ? Icon(Icons.check)
                                                    //     : null,
                                                  ),
                                                ));
                                          })))
                                ],
                              ),
                            ))),
                            // GestureDetector(
                            //   onTap: () {
                            //     DatePicker.showDatePicker(context,
                            //         showTitleActions: true,
                            //         minTime: now,
                            //         maxTime: now.add(Duration(days: 365)));
                            //     //onConfirm:(date) => ;
                            //   },
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8),
                            //     child: Align(
                            //         alignment: Alignment.topCenter,
                            //         child: Icon(
                            //           Icons.calendar_today,
                            //           color: Colors.white,
                            //           size: 70,
                            //         )),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                      //BookingDetails(),
                      //BookingPropertyFeatures(),
                      SizedBox(
                        height: 10.0,
                      ),
                      time
                          ? (ElevatedButton(
                              child: Text("BOOK ROOM"),
                              onPressed: () {},
                            ))
                          : (ElevatedButton(
                              child: Text("BOOK ROOM"),
                              onPressed: null,
                            ))
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
          }),
    );
  }
}
