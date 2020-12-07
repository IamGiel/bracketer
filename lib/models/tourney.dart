import 'package:bracketer/models/participant.dart';

class Tourney {
  String name;
  String totalTeams;
  String seriesLength;
  List participants;

  Tourney(
      String name, String totalTeams, String seriesLength, List participants) {
    this.name = name;
    this.totalTeams = totalTeams;
    this.seriesLength = seriesLength;
    this.participants = participants;
  }
}
