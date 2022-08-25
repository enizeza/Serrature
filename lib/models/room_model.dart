import 'package:cloud_firestore/cloud_firestore.dart';

class Room {
  final String room_code;
  final String room_name;
  final String image_id;
  final price_half_hour;
  final String room_description;
  final String room_number;

  const Room({
    required this.room_code,
    required this.room_name,
    required this.image_id,
    required this.price_half_hour,
    required this.room_description,
    required this.room_number,
  });

  static Room fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Room(
        room_code: snapshot["room_code"],
        room_name: snapshot["room_name"],
        price_half_hour: snapshot["price_half_hour"],
        image_id: snapshot["image_id"],
        room_description: snapshot['room_description'],
        room_number: snapshot['room_number']);
  }

  Map<String, dynamic> toJson() => {
        "room_code": room_code,
        "room_name": room_name,
        "price_half_hour": price_half_hour,
        "image_id": image_id,
        'room_description': room_description,
        'room_number': room_number,
      };

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        room_code: json['room_code'] as String,
        room_name: json['room_name'] as String,
        price_half_hour: json['price_half_hour'] as double,
        image_id: json['image_id'] as String,
        room_description: json['room_description'] as String,
        room_number: json['room_number'] as String,
      );
}
