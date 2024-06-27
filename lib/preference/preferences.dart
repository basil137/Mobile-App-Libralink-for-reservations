import 'package:Libralink/util/parameters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SetPref {
  static void setprefUser(String name, id) async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    sharedpref.setString("userName", name);
    sharedpref.setString("userId", id);
  }

  static void setprefTimeFrom(int hour, int min) async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    sharedpref.setInt("hourFrom", hour);
    sharedpref.setInt("minuteFrom", min);
  }

  static void setprefTimeTo(int hour, int min) async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    sharedpref.setInt("hourTo", hour);
    sharedpref.setInt("minuteTo", min);
  }

  static void setprefInfoReserve(String idTable, String sizeTable, String floor,
      String timeFrom, String timeTo, String dayTable) async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    sharedpref.setString(ParametersReservationTable.floorTableReserve, floor);
    sharedpref.setString(
        ParametersReservationTable.sizeTableReserve, sizeTable);
    sharedpref.setString(ParametersReservationTable.idTableReserve, idTable);
    sharedpref.setString(ParametersReservationTable.timeFrom, timeFrom);
    sharedpref.setString(ParametersReservationTable.timeTo, timeTo);
    sharedpref.setString(ParametersFloor.dayTable, dayTable);
  }

  static void setprefDate(int dateDay,int dateMonth,int dateyear) async {
    SharedPreferences sharedpref = await SharedPreferences.getInstance();
    sharedpref.setInt(ParametersReservationTable.dateDay, dateDay);
    sharedpref.setInt(ParametersReservationTable.datemonth, dateMonth);
    sharedpref.setInt(ParametersReservationTable.dateyear, dateyear);

  }
}
