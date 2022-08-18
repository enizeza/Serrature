// import 'dart:ffi';

// import 'package:serrature/models/room_model.dart';

// class Booking {
//   DateTime? start;
//   DateTime? finish;
//   var total;
//   Room? room;
//   var user_uid;

//   Booking(this.start, this.finish, this.room, this.total, this.user_uid);

//   Map<String, dynamic> toJson() => {
//         "finish": finish,
//         "start": start,
//         "total": total,
//         "room": room,
//         "user_uid": user_uid,
//       };

//   Booking.fromSnapshot(snapshot)
//       : finish = snapshot.data()["finish"].toDate(),
//         start = snapshot.data()["start"].toDate(),
//         total = snapshot.data()["total"],
//         user_uid = snapshot.data()["user_uid"],
//         room = snapshot.data()["room"];
// }

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String room_code;
  final String room_name;
  final String image_id;
  final price_half_hour;
  final String room_description;
  final String room_number;
  final DateTime start;
  final DateTime finish;
  final total;
  final String user_uid;

  const Booking({
    required this.room_code,
    required this.room_name,
    required this.image_id,
    required this.price_half_hour,
    required this.room_description,
    required this.room_number,
    required this.start,
    required this.finish,
    required this.total,
    required this.user_uid,
  });

  static Booking fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Booking(
        room_code: snapshot["room_code"],
        room_name: snapshot["room_name"],
        price_half_hour: snapshot["price_half_hour"],
        image_id: snapshot["image_id"],
        room_description: snapshot['room_description'],
        start: snapshot['start'].toDate(),
        finish: snapshot['finish'].toDate(),
        total: snapshot['total'],
        user_uid: snapshot['user_uid'],
        room_number: snapshot['room_number']);
  }

  Map<String, dynamic> toJson() => {
        "room_code": room_code,
        "room_name": room_name,
        "price_half_hour": price_half_hour,
        "image_id": image_id,
        'room_description': room_description,
        'room_number': room_number,
        'start': start,
        'finish': finish,
        'total': total,
        'user_uid': user_uid,
      };

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        room_code: json['room_code'] as String,
        room_name: json['room_name'] as String,
        price_half_hour: json['price_half_hour'] as double,
        image_id: json['image_id'] as String,
        room_description: json['room_description'] as String,
        room_number: json['room_number'] as String,
        start: json['start'] as DateTime,
        finish: json['finish'] as DateTime,
        total: json['total'] as double,
        user_uid: json['user_uid'] as String,
      );
}
