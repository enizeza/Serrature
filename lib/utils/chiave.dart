/*import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Socket? socket;

class Chiave extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            ElevatedButton(
              child: const Text('Apri'),
              onPressed: () => apri(0x00),
            ),
          ],
        ),
      ),
    );
  }

  void apri(pos) {
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
    }).catchError((AsyncError e) {
      print("Unable to connect: $e");
    });
    //Connect standard in to the socket
    stdin.listen(
        (data) => socket?.write(new String.fromCharCodes(data).trim() + '\n'));
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

void dataHandler(data) {
  print(new String.fromCharCodes(data).trim());
}

void errorHandler(error, StackTrace trace) {
  print(error);
}

void doneHandler() {
  socket?.destroy();
}*/

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
//import 'package:doors/cloud_firestore.dart';
import 'package:serrature/utils/connection.dart';
import 'package:flutter/material.dart';
//import 'package:doors/flutter_bluetooth_serial.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Chiave extends StatefulWidget {
  //final BluetoothDevice server;

  //const ChatPage({required this.server});

  @override
  _Chiave createState() => new _Chiave();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _Chiave extends State<Chiave> {
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
      // socket?.close();
      // socket?.destroy();
      // socket = null;
    }).catchError((Object e) {
      print("Unable to connect: $e");
    });
    //Connect standard in to the socket
    stdin.listen(
        (data) => socket?.write(new String.fromCharCodes(data).trim() + '\n'));
    socket?.close();
    socket?.destroy();
    socket = null;
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
    return Container(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: (Text('Key'))),
        body: Container(
          padding: const EdgeInsets.all(5),
          width: double.infinity,
          height: 300,
          child: (open || available)
              ? TextButton(
                  onPressed: () => {
                    apri(0x00) /*SocketClient Connection(0x00, 0x31).lancia()*/
                  },
                  //isConnected ? () => _sendMessage('1') : null,
                  child: ClipOval(child: Image.asset('assets/images/lock.png')),
                )
              : TextButton(
                  onPressed: () => {},
                  //isConnected ? () => _sendMessage('0') : null,
                  child: ClipOval(
                      child: Image.asset('assets/images/engineOff.png')),
                ),

          /*TextButton(
                          onPressed:
                              isConnected ? () => _sendMessage('1') : null,
                          child: ClipOval(
                              child: Image.asset('images/engineOn.png')),
                        ),
                        TextButton(
                          onPressed:
                              isConnected ? () => _sendMessage('0') : null,
                          child: ClipOval(
                              child: Image.asset('images/engineOff.png')),
                        ),*/
        ),
      ),
    );
  }

  /*void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        //connection.output.add(utf8.encode(text + "\r\n"));
        connection!.output.add(Uint8List.fromList(utf8.encode(text + "\r\n")));
        await connection!.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });

        if (text == '1') {
          text = "On";
        }
        if (text == '0') {
          text = "Off";
        }
        final docComandi =
            FirebaseFirestore.instance.collection('comandi').doc();

        final comandi = Comandi(
          id: docComandi.id,
          command: text,
          date: DateTime.now(),
        );
        final json = comandi.toJson();

        await docComandi.set(json);
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}

class Comandi {
  String id;
  final String command;
  final DateTime date;

  Comandi({
    this.id = '',
    required this.command,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'command': command,
        'date': date,
      };*/
}
