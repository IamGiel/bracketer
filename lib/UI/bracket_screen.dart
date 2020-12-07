import 'package:bracketer/models/participant.dart';
import 'package:bracketer/models/tourney.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BracketScreen extends StatefulWidget {
  BracketScreen({Key key, this.tourData, this.pList}) : super(key: key);

  final Tourney tourData;
  final pList;

  @override
  _BracketScreenState createState() => _BracketScreenState();
}

class _BracketScreenState extends State<BracketScreen> {
  @override
  Widget build(BuildContext context) {
    // print("klklklklklkl ${widget.pList["participants"]}");
    var size = MediaQuery.of(context).size;
    /*24 is for notification bar on Android*/
    // final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemHeight = (size.height) / 22;
    final double itemWidth = size.width / 2;
    List<String> widgetList = ['A', 'B', 'C'];

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
            title: Text("Bracket: Order of Play"),
            elevation: 0,
            backgroundColor: Colors.blue,
            actions: [
              Padding(
                padding: EdgeInsets.all(18),
                child: Icon(Icons.more_vert),
              )
            ],
          ),
          body: SingleChildScrollView(
              child: GridView.count(
            childAspectRatio: (itemWidth / itemHeight),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 1,
            children: widgetList.map((String value) {
              return Container(
                color: Colors.green,
                margin: EdgeInsets.all(1.0),
                child: Center(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          )

              // [
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.start,
              //     children: [buildContainer()],
              //   )
              // ]

              )),
    ));
  }

  Container buildContainer() {
    return Container(
      width: 200,
      margin: const EdgeInsets.all(30.0),
      padding: const EdgeInsets.all(10.0),
      decoration: myBoxDecoration(), //       <--- BoxDecoration here
      child: Text(
        "seed 1",
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }

  BoxDecoration myBoxDecoration() {
    return BoxDecoration(
      border: Border.all(),
    );
  }

  FutureBuilder<DocumentSnapshot> buildFutureBuilder(
      CollectionReference users) {
    // return FutureBuilder<DocumentSnapshot>(
    //   future: users.doc(widget.tournName.name).get(),
    //   builder:
    //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //     if (snapshot.hasError) {
    //       return Text("Something went wrong");
    //     }
    //     // "Rank ${index + 1}: ${data['participants'][index]['pName']}"
    //     if (snapshot.connectionState == ConnectionState.done) {
    //       Map<String, dynamic> data = snapshot.data.data();
    //       // return Text("${data['participants']}");
    //       return MaterialApp(
    //         home: Container(
    //           child: Scaffold(
    //             appBar: AppBar(
    //               // leading: IconButton(
    //               //   icon: Icon(Icons.arrow_back_ios),
    //               //   onPressed: () {
    //               //     Navigator.pop(context, true);
    //               //   },
    //               // ),
    //               title: Text("Here it is..."),
    //               elevation: 0,
    //               backgroundColor: Colors.blue,
    //               actions: [
    //                 Padding(
    //                   padding: EdgeInsets.all(18),
    //                   child: IconButton(
    //                     icon: Icon(Icons.more_vert),
    //                     onPressed: () {
    //                       showDialog(
    //                           context: context,
    //                           child: AlertDialog(
    //                             title: Text("My Super title"),
    //                             content: Text("Hello World"),
    //                           ));
    //                     },
    //                   ),
    //                 )
    //               ],
    //             ),
    //             body: Column(
    //               children: [
    //                 SizedBox(
    //                   height: 20,
    //                 ),
    //                 Center(
    //                   child: Text("widget.tournName.name",
    //                       style: TextStyle(
    //                           color: Colors.black,
    //                           fontSize: 28,
    //                           fontWeight: FontWeight.bold,
    //                           wordSpacing: 2,
    //                           letterSpacing: 2)),
    //                 ),
    //                 SizedBox(
    //                   height: 20,
    //                 ),
    //                 Flexible(
    //                   child: ListView.separated(
    //                     // shrinkWrap: true,
    //                     itemCount: data['participants'].length,
    //                     itemBuilder: (_, index) {
    //                       return ListTile(
    //                         title: Text(
    //                             "Rank ${index + 1}: ${data['participants'][index]['pName']}"),
    //                         selected: index == _selectedIndex,
    //                         onTap: () {},
    //                         trailing: IconButton(
    //                           icon: Icon(
    //                             Icons.more_horiz,
    //                             color: Colors.blue,
    //                           ),
    //                           onPressed: () {
    //                             setState(() {
    //                               _selectedIndex = index;
    //                             });
    //                             print(
    //                                 "Pressed: ${data['participants'][index]['pName']} index: $index");
    //                             Navigator.push(
    //                                 context,
    //                                 MaterialPageRoute(
    //                                     builder: (context) =>
    //                                         ParticipantDetail()));
    //                           },
    //                         ),
    //                       );
    //                     },
    //                     separatorBuilder: (BuildContext context, int index) =>
    //                         const Divider(),
    //                   ),
    //                 ),
    //                 Row(
    //                   children: <Widget>[
    //                     Expanded(flex: 1, child: Container()),
    //                     Expanded(
    //                       flex: 4,
    //                       child: RaisedButton(
    //                         color: Colors.green[50],
    //                         onPressed: () => print("Button Pressed"),
    //                         child: new Text(
    //                           "Simulator",
    //                           style: TextStyle(color: Colors.blue),
    //                         ),
    //                       ),
    //                     ),
    //                     Expanded(
    //                       flex: 2,
    //                       child: Container(),
    //                     ),
    //                     Expanded(
    //                       flex: 4,
    //                       child: RaisedButton(
    //                         color: Colors.blue[50],
    //                         onPressed: () => {
    //                           // print("Button Pressed")
    //                           Navigator.push(
    //                               context,
    //                               MaterialPageRoute(
    //                                   builder: (context) => BracketScreen()))
    //                         },
    //                         child: new Text(
    //                           "Update Match",
    //                           style: TextStyle(color: Colors.blue),
    //                         ),
    //                       ),
    //                     ),
    //                     Expanded(flex: 1, child: Container()),
    //                   ],
    //                 ),
    //                 SizedBox(height: 100)
    //               ],
    //             ),
    //           ),
    //         ),
    //       );
    //     }

    //     return Text("loading");
    //   },
    // );
  }
}
