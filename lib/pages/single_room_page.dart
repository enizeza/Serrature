import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:serrature/pages/booking_screen.dart';
import 'package:serrature/models/room_model.dart';

class SingleRoomPage extends StatelessWidget {
  final Room room;
  const SingleRoomPage({required this.room});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightFromWhiteBg = size.height - 300.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Room detail"),
      ),
      body: Builder(builder: (BuildContext context) {
        //double heightFromWhiteBg =
        //  size.height - 200.0; // height for white section
        return Container(
          height: size.height,
          child: Stack(
            children: [
              Positioned(
                width: size.width,
                child: Container(
                  height: size.height,
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: AssetImage("assets/images/${room.image_id}.png"),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                width: size.width,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            ("${room.room_name}"),
                            style: TextStyle(
                              fontSize: 34.0,
                              height: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          /*Icon(
                            FlutterIcons.map_pin_fea,
                            color: Color.fromRGBO(138, 150, 190, 1),
                          ),*/
                        ],
                      ),
                      Text(
                        ("${room.room_description}"),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 15.0,
                          height: 1.5,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 16.0, right: 5.0),
                        height: 56.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    //text: "120\$ / ",
                                    text: "${room.price_half_hour}\€ / ",
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontSize: 32.0,
                                    ),
                                  ),
                                  TextSpan(
                                    text: " 30 minutes",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BookingScreen(room: room)),
                                );
                              },
                              child: Container(
                                height: 45.0,
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24.0),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  "BOOK ROOM",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
