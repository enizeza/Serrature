import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:serrature/booking_details.dart';
import 'package:flutter/material.dart';
import 'package:serrature/models/room_model.dart';
import 'package:serrature/utils/time_slot.dart';

import 'package:firebase_auth/firebase_auth.dart';
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
  bool available = false;
  List<int> options = List.filled(TIME_SLOT.length, 1);

  void selected_date(DateTime data) {
    setState(() {
      now = data;
    });
  }

  void notAvailable() {
    available = false;
  }

  void Available() {
    available = true;
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
              final data = snapshot.data!.docs;
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
                                        color: Colors.black),
                                  ),
                                  Text(
                                    '${now.day}',
                                    style: GoogleFonts.robotoMono(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${DateFormat.EEEE().format(now)}',
                                    style: GoogleFonts.robotoMono(
                                      color: Colors.black,
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
                                            minTime: DateTime.now(),
                                            maxTime:
                                                now.add(Duration(days: 365)),
                                            onConfirm: (date) =>
                                                selected_date(date));
                                      },
                                    ),
                                  ),
                                  Expanded(
                                      child: GridView.builder(
                                          itemCount: TIME_SLOT.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3),
                                          itemBuilder: ((context, index) {
                                            if (snapshot.data != null) {
                                              for (var dati
                                                  in snapshot.data!.docs) {
                                                DateTime start_dt =
                                                    dati["start"].toDate();
                                                // print(dati["start"]);
                                                // print(start_dt);

                                                DateTime finish_dt =
                                                    dati["finish"].toDate();

                                                final tempi = TIME_SLOT
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

                                                String actual_time =
                                                    DateFormat.Hm()
                                                        .format(DateTime.now());

                                                if ((start_dt.year ==
                                                            now.year &&
                                                        start_dt.month ==
                                                            now.month &&
                                                        start_dt.day ==
                                                            now.day &&
                                                        (tempo_start_book_db
                                                                .compareTo(
                                                                    slot_inizio) ==
                                                            0) &&
                                                        (tempo_finish_book_db
                                                                .compareTo(
                                                                    slot_fine) ==
                                                            0)) ||
                                                    ((actual_time.compareTo(
                                                                slot_inizio) >
                                                            0) &&
                                                        (actual_time.compareTo(
                                                                slot_fine) >
                                                            0))) {
                                                  options[index] = 0;
                                                } else {}
                                              }
                                              ;
                                            }

                                            if (options[index] == 1) {
                                              Available();
                                            } else {
                                              notAvailable();
                                            }

                                            return GestureDetector(
                                                onTap: () {
                                                  if (available == true) {
                                                    selected_time(TIME_SLOT
                                                        .elementAt(index));
                                                  } else {
                                                    Null;
                                                  }
                                                  ;
                                                },
                                                child: Card(
                                                  color: available == false
                                                      ? Colors.red
                                                      : slot_time ==
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
                                                          available == false
                                                              ? Text(
                                                                  'Not Available')
                                                              : Text(
                                                                  'Available')
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ));
                                          })))
                                ],
                              ),
                            ))),
                          ],
                        ),
                      ),
                      //BookingDetails(),
                      //BookingPropertyFeatures(),
                      SizedBox(
                        height: 10.0,
                      ),
                      time && slot_time != null
                          ? (ElevatedButton(
                              child: Text("BOOK ROOM"),
                              onPressed: () {
                                Crea();
                                //print(now.toString() + " + " + slot_time);
                                // Booking booking = Booking(room_code: widget.room.room_code, room_name: widget.room.room_name, image_id: widget.room.image_id, price_half_hour: widget.room.price_half_hour, room_description: widget.room.room_description, room_number: widget.room.room_number, start: start, finish: finish, total: widget.room.price_half_hour, user_uid: uid)
                                // FirebaseFirestore.instance
                                //     .collection("booking")
                                //     .add(booking.toJson());
                              },
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
            if (snapshot.hasError) {
              print(snapshot.error);
              //! do any error handling here
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

  void Crea() {
    final tempi = slot_time.split('-');

    final hm_inizio = tempi[0].split(':');
    final hour_inizio = int.parse(hm_inizio[0]);
    final minute_inizio = int.parse(hm_inizio[1]);

    final hm_fine = tempi[1].split(':');
    final hour_fine = int.parse(hm_fine[0]);
    final minute_fine = int.parse(hm_fine[1]);

    // String tempo_start_book_db = DateFormat.Hm().format(start_dt);
    // String tempo_finish_book_db = DateFormat.Hm().format(finish_dt);
    DateTime new_start = new DateTime(
      now.year,
      now.month,
      now.day,
      hour_inizio,
      minute_inizio,
    );

    DateTime new_fine = new DateTime(
      now.year,
      now.month,
      now.day,
      hour_fine,
      minute_fine,
    );

    print(new_fine.toString());

    var inizio = Timestamp.fromDate(new_start);
    var fine = Timestamp.fromDate(new_fine);

    print(fine);
    Booking booking = Booking(
        room_code: widget.room.room_code,
        room_name: widget.room.room_name,
        image_id: widget.room.image_id,
        price_half_hour: widget.room.price_half_hour,
        room_description: widget.room.room_description,
        room_number: widget.room.room_number,
        start: new_start,
        finish: new_fine,
        total: widget.room.price_half_hour,
        user_uid: uid);
    FirebaseFirestore.instance.collection("booking").add(booking.toJson());
  }
}
