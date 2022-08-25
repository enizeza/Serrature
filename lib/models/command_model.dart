import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class Command {
  final String cmd;
  final bool done;
  final String id;
  final String len;
  final String pos;
  final String response;
  final String user;

  const Command({
    required this.cmd,
    required this.done,
    required this.id,
    required this.len,
    required this.pos,
    required this.response,
    required this.user,
  });

  static Command fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Command(
        cmd: snapshot["cmd"],
        done: snapshot["done"],
        id: snapshot["id"],
        len: snapshot["len"],
        pos: snapshot['pos'],
        response: snapshot['response'],
        user: snapshot['user']);
  }

  Map<String, dynamic> toJson() => {
        "cmd": cmd,
        "done": done,
        "id": id,
        "len": len,
        'pos': pos,
        'response': response,
        'user': user,
      };

  factory Command.fromJson(Map<String, dynamic> json) => Command(
        cmd: json['cmd'] as String,
        done: json['done'] as bool,
        id: json['id'] as String,
        len: json['len'] as String,
        pos: json['pos'] as String,
        response: json['response'] as String,
        user: json['user'] as String,
      );

  Crea(Command command) {
    FirebaseFirestore.instance
        .collection("command")
        .add(command.toJson())
        .then((value) {
      print(value.id);
    });
  }
}
