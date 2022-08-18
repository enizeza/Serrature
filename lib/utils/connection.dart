import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

Socket? socket;

class Connection {
  var pos;
  var cmd;

  Connection(this.pos, this.cmd);

  void lancia() {
    Socket.connect("192.168.2.99", 5000).then((Socket sock) {
      socket = sock;
      var start = 0x02;
      var finish = 0x03;
      //var cmd = 0x31;
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

  void dataHandler(data) {
    print(new String.fromCharCodes(data).trim());
  }

  void errorHandler(error, StackTrace trace) {
    print(error);
  }

  void doneHandler() {
    socket?.destroy();
  }
}
