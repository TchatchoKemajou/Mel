import 'package:shared_preferences/shared_preferences.dart';

class Utilitaire{

  getLocation() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var place = localStorage.getString('place');
    return '?place=$place';
  }

  setLocation(dynamic place) async {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('place', place);
        //localStorage.setString('user', json.encode(body['user']));
  }
}