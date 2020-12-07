import 'package:bracketer/models/tourney.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ParticipantDetail extends StatefulWidget {
  final Tourney tourData;
  final index;

  const ParticipantDetail({Key key, this.tourData, @required this.index})
      : super(key: key);
  @override
  _ParticipantDetailState createState() => _ParticipantDetailState();
}

String getInitials({String string, int limitTo}) {
  var buffer = StringBuffer();
  var split = string.split(' ');
  for (var i = 0; i < (limitTo ?? split.length); i++) {
    buffer.write(split[i][0]);
  }

  return buffer.toString();
}

// get details from firestore
// get docs from collections

class _ParticipantDetailState extends State<ParticipantDetail> {
  @override
  Widget build(BuildContext context) {
    print(" sadas >>> ${widget.index}");
    CollectionReference users =
        FirebaseFirestore.instance.collection('created_tournament');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc("${widget.tourData.name}").get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          var name = data['participants'][widget.index]['pName'];
          var special = data['participants'][widget.index]['pSpecial'];
          var offense = data['participants'][widget.index]['pOffense'];
          var defense = data['participants'][widget.index]['pDefense'];
          var loc = data['participants'][widget.index]['pName'];

          var output = getInitials(string: name, limitTo: 1);

          return MaterialApp(
              home: Container(
            child: Scaffold(
                // backgroundColor: Colors.black,
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                  ),
                  title: Text("Player Profile"),
                  elevation: 0,
                  backgroundColor: Colors.blue,
                  actions: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Icon(Icons.more_vert),
                    )
                  ],
                ),
                body: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 28, top: 30),
                        child: CircleAvatar(
                            child: Text(
                              "$output",
                              style: TextStyle(fontSize: 34),
                            ),
                            radius: 40),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18, top: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("$name",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 23,
                                    color: Colors.blue)),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.red[200],
                                    size: 17,
                                  ),
                                  Text(
                                    "Garner, NC",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        wordSpacing: 2,
                                        letterSpacing: 4),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Row(
                      children: [
                        Text(
                          "Special:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "$special",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Row(
                      children: [
                        Text(
                          "Offensive Credit:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "$offense",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Row(
                      children: [
                        Text(
                          "Defensive Credit:",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "$defense",
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ])),
          ));
        }

        return Container();
      },
    );
  }
}
