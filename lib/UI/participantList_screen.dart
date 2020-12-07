import 'package:bracketer/UI/bracket_screen.dart';
import 'package:bracketer/UI/participantDetail_screen.dart';
import 'package:bracketer/models/tourney.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class ParticipantList extends StatefulWidget {
  final Tourney tournName;
  var participantLists;

  ParticipantList({Key key, this.tournName, @required this.participantLists})
      : super(key: key);

  @override
  _ParticipantListState createState() => _ParticipantListState();
}

class _ParticipantListState extends State<ParticipantList> {
  int _selectedIndex;
  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('created_tournament');

    return MaterialApp(
      home: Scaffold(
          body: Stack(children: [
        Padding(
          padding: EdgeInsets.all(20),
        ),
        buildFutureBuilder(users),
      ])),

      // child: Expanded(
      //   child: buildFutureBuilder(users)
      // )
    );
  }

  FutureBuilder<DocumentSnapshot> buildFutureBuilder(
      CollectionReference users) {
    print("im participantList ${widget.tournName.name}");
    print("im participantList items >>  ${widget.participantLists}");
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.tournName.name).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        // "Rank ${index + 1}: ${data['participants'][index]['pName']}"
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          widget.participantLists = data;
          print("${data['participants']}");
          return MaterialApp(
            home: Container(
              child: Scaffold(
                appBar: AppBar(
                  // leading: IconButton(
                  //   icon: Icon(Icons.arrow_back_ios),
                  //   onPressed: () {
                  //     Navigator.pop(context, true);
                  //   },
                  // ),
                  title: Text("Here it is..."),
                  elevation: 0,
                  backgroundColor: Colors.blue,
                  actions: [
                    Padding(
                      padding: EdgeInsets.all(18),
                      child: IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {
                          showDialog(
                              context: context,
                              child: AlertDialog(
                                title: Text("My Super title"),
                                content: Text("Hello World"),
                              ));
                        },
                      ),
                    )
                  ],
                ),
                body: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text("${widget.tournName.name}",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              wordSpacing: 2,
                              letterSpacing: 2)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Flexible(
                      child: ListView.separated(
                        // shrinkWrap: true,
                        itemCount: data['participants'].length,
                        itemBuilder: (_, index) {
                          return ListTile(
                            title: Text(
                                "Rank ${index + 1}: ${data['participants'][index]['pName']}"),
                            selected: index == _selectedIndex,
                            onTap: () {},
                            trailing: IconButton(
                              icon: Icon(
                                Icons.arrow_right,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                setState(() {
                                  _selectedIndex = index;
                                });
                                print(
                                    "Pressed: ${data['participants'][index]['pName']} index: $index");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ParticipantDetail(
                                              tourData: widget.tournName,
                                              index: index,
                                            )));
                              },
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            const Divider(),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(flex: 1, child: Container()),
                        Expanded(
                          flex: 4,
                          child: RaisedButton(
                            color: Colors.green[50],
                            onPressed: () => print("Button Pressed"),
                            child: new Text(
                              "Simulator",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(),
                        ),
                        Expanded(
                          flex: 4,
                          child: RaisedButton(
                            color: Colors.blue[50],
                            onPressed: () => {
                              // print("Button Pressed")
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BracketScreen(
                                            pList: data,
                                          )))
                            },
                            child: new Text(
                              "Update Match",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ),
                        Expanded(flex: 1, child: Container()),
                      ],
                    ),
                    SizedBox(height: 100)
                  ],
                ),
              ),
            ),
          );
        }

        return Text("loading");
      },
    );
  }
}
