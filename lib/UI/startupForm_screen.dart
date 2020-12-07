import 'package:bracketer/UI/addParticipantForm_screen.dart';
import 'package:bracketer/models/tourney.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class StartUpForm extends StatefulWidget {
  @override
  MyStartUpFormState createState() {
    return MyStartUpFormState();
  }
}

class MyStartUpFormState extends State<StartUpForm> {
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyStartUpFormState>.
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  var eTitle;
  var eTeamNum;
  var eSeriesNum;
  static var tournamentTitle;

  TextEditingController _titleController,
      _teamNumController,
      _seriesNumController;

  CollectionReference tournamentCreated =
      FirebaseFirestore.instance.collection('created_tournament');
  Future<void> addNewTournament(name, numTeams, serLength) {
    // Call the user's CollectionReference to add a new user
    this.setState(() {
      tournamentTitle = name;
    });
    return tournamentCreated
        .doc(eTitle)
        .set({
          'tournament_name': name,
          'number_Teams': numTeams,
          'series_length': serLength
        })
        .then((value) => print("Tournament Added"))
        .catchError((error) => print("Failed to add tournament: $error"));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final _titleController = TextEditingController();
    final _teamNumController = TextEditingController();
    final _seriesNumController = TextEditingController();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _titleController.dispose();
    _teamNumController.dispose();
    _seriesNumController.dispose();
    super.dispose();
  }

  void performLogin() {
    final form = _formKey.currentState;

    if (_formKey.currentState.validate()) {
      form.save();

      // If the form is valid, display a Snackbar.
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Preparing... ${eTitle}'),
        ),
      );

      final data = Tourney(eTitle, eTeamNum, eSeriesNum, []);
      addNewTournament(eTitle, eTeamNum, eSeriesNum);

      // USE FOR PROD:
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AddParticipantList(tournamentData: data)));
    }
    // USE FOR TESTING:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => SetupTwoForm()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Container(
            padding: const EdgeInsets.all(30.0),
            color: Colors.transparent,
            child: Container(
              child: Center(
                  child: Column(children: [
                Padding(padding: EdgeInsets.only(top: 140.0)),
                Text(
                  'Bracket Set Up',
                  style: TextStyle(
                      color: Colors.blue[300],
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold),
                ),
                Padding(padding: EdgeInsets.only(top: 50.0)),
                TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Enter Tourney Title",
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val.length == 0) {
                        return "Conference title cannot be empty";
                      }
                    },
                    onSaved: (val) => {eTitle = val},
                    keyboardType: TextInputType.name,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.singleLineFormatter
                    ],
                    style: buildTextStyle()),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _teamNumController,
                    decoration: InputDecoration(
                      labelText: "Number of Participants",
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val.length == 0) {
                        return "Field cannot be empty";
                      } else if (int.parse(val).isOdd) {
                        return "Must be an even number";
                      }
                    },
                    onSaved: (val) => {eTeamNum = val},
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    style: buildTextStyle()),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    controller: _seriesNumController,
                    decoration: InputDecoration(
                      labelText: "Enter Series Length",
                      fillColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val.length == 0) {
                        return "Field cannot be empty";
                      } else if (int.parse(val).isEven) {
                        return "Must be an odd number";
                      } else if (int.parse(val) > 7) {
                        return "Max series length is 7";
                      }
                    },
                    onSaved: (val) => {eSeriesNum = val},
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    style: buildTextStyle()),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      performLogin();
                    },
                    child: Text('Submit'),
                  ),
                ),
              ])),
            )));
  }

  TextStyle buildTextStyle() {
    return TextStyle(
      fontFamily: "Poppins",
    );
  }
}
