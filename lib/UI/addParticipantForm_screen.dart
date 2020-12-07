import 'package:bracketer/UI/participantList_screen.dart';
import 'package:bracketer/models/participant.dart';
import 'package:bracketer/models/tourney.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddParticipantList extends StatefulWidget {
  final Tourney tournamentData;

  AddParticipantList({Key key, this.tournamentData}) : super(key: key);

  @override
  MyAddParticipantList createState() {
    return MyAddParticipantList(this.tournamentData);
  }
}

class MyAddParticipantList extends State<AddParticipantList> {
  MyAddParticipantList(Tourney tournamentData);
  // Tourney tournamentData;
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  final _yoMyKey = GlobalKey<ScaffoldState>();

  var _eSeedName;
  var _special;
  var _eOff;
  var _eDef;
  var _eCityState;

  var stringPlayer = "playerName";
  var stringSpecial = "playerSpecial";
  var stringOffense = "playerOffense";
  var stringDefense = "playerDefense";

  var counter = 1;

  List participants = []; //blank initially

  TextEditingController _nameController,
      _specialController,
      _offenseController,
      _defenseController,
      _cityStateController;

  CollectionReference particpantCreated =
      FirebaseFirestore.instance.collection('created_tournament');

  Future<void> addNewParticipant(
      _eSeedName, _special, _eOff, _eDef, _eCityState) {
    // counter++;
    // Call the user's CollectionReference to add a new user
    var obj = [
      {
        'pName': _eSeedName,
        'pSpecial': _special,
        'pOffense': _eOff,
        'pDefense': _eDef,
        'pCityState': _eCityState
      }
    ];
    return particpantCreated
        .doc(widget.tournamentData.name)
        .update({
          "participants": FieldValue.arrayUnion(obj)
          //add your data that you want to upload
        })
        .then((value) => print("Participant Added"))
        .catchError((error) => print("Failed to add participant: $error"));

    // .set({
    //   'pName': _eSeedName,
    //   'pSpecial': _special,
    //   'pOffense': _eOff,
    //   'pDefense': _eDef
    // }, SetOptions(merge: true))
  }

  void performAddParticipant() {
    final form = _formKey.currentState;
    if (_formKey.currentState.validate()) {
      setState(() {
        counter++;
      });
      _yoMyKey.currentState.showSnackBar(SnackBar(
        content: Text('Listing... $_eSeedName'),
      ));

      form.save();

      final data = Participant(_eSeedName, _special, _eOff, _eDef, _eCityState);
      participants.add(data);
      // push data to array defined in the model Tourney

      addNewParticipant(_eSeedName, _special, _eOff, _eDef, _eCityState);
      if (counter == (int.parse(widget.tournamentData.totalTeams) + 1)) {
        // USE FOR PROD:
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ParticipantList(
                      tournName: widget.tournamentData,
                      participantLists: participants,
                    )));
      }
      // clear the form for new entries
      _formKey.currentState.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("addparticipant class data: ${widget.tournamentData.name}");
    return Container(
      decoration: BoxDecoration(
          color: Color(0xff7c94b6),
          image: DecorationImage(
              image: AssetImage("assets/bracketBGImage.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        key: _yoMyKey,
        body: Form(
            key: _formKey,
            child: Container(
                padding: const EdgeInsets.all(30.0),
                color: Colors.transparent,
                child: Container(
                  child: Center(
                      child: Column(children: [
                    Padding(
                        padding: EdgeInsets.only(top: 140.0),
                        child: Text(
                          "${widget.tournamentData.name}",
                          style: TextStyle(
                              color: Colors.blue[200],
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        )),
                    SizedBox(height: 20),
                    Text(
                      'Add \'em ${widget.tournamentData.totalTeams} Participants',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(padding: EdgeInsets.only(top: 50.0)),
                    TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "Seed $counter (name)",
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Specify a name";
                          }
                        },
                        onSaved: (val) => {_eSeedName = val},
                        keyboardType: TextInputType.name,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        style: buildTextStyle()),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        controller: _specialController,
                        decoration: InputDecoration(
                          labelText: "Special Abilities",
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Specify a strength or a special ability";
                          }
                        },
                        onSaved: (val) => {_special = val},
                        keyboardType: TextInputType.name,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        style: buildTextStyle()),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        controller: _offenseController,
                        decoration: InputDecoration(
                          labelText: "Offensive Pts",
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        validator: (val) {
                          if (val.length == 0 || int.parse(val) > 10) {
                            return "Specify a range 0 - 10";
                          }
                        },
                        onSaved: (val) => {_eOff = val},
                        keyboardType: TextInputType.name,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: buildTextStyle()),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        controller: _defenseController,
                        decoration: InputDecoration(
                          labelText: "Defensive Pts",
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        validator: (val) {
                          if (val.length == 0 || int.parse(val) > 10) {
                            return "Specify a range 0 - 10";
                          }
                        },
                        onSaved: (val) => {_eDef = val},
                        keyboardType: TextInputType.name,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        style: buildTextStyle()),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                        controller: _cityStateController,
                        decoration: InputDecoration(
                          labelText: "City and State ya hail from",
                          fillColor: Colors.transparent,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                            borderSide: BorderSide(),
                          ),
                          //fillColor: Colors.green
                        ),
                        validator: (val) {
                          if (val.length == 0) {
                            return "Specify a place so we know were ya from";
                          }
                        },
                        onSaved: (val) => {_eCityState = val},
                        keyboardType: TextInputType.text,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.singleLineFormatter
                        ],
                        style: buildTextStyle()),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // print(context);

                          performAddParticipant();
                        },
                        child: Text('Add'),
                      ),
                    ),
                  ])),
                ))),
      ),
    );
  }

  TextStyle buildTextStyle() {
    return TextStyle(
      fontFamily: "Poppins",
    );
  }
}
