import 'package:flutter/cupertino.dart';
import 'package:flutter_app/utilitaire.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageChangeProvider with ChangeNotifier{
  Utilitaire utilitaire = Utilitaire();
  Locale _currentLocale;
  String _currentLocaleName = "Français";
  bool _doneLoading = false;
  SharedPreferences localStorage;

  Locale get currentLocale => _currentLocale;
  String get currentLocaleName => _currentLocaleName;

  bool get doneLoading => _doneLoading;

  set doneLoading(bool value) {
    _doneLoading = value;
    notifyListeners();
  }

  LanguageChangeProvider(){
    loadLanguage();
  }
  changeLocaleName(String value) {
    _currentLocaleName = value;
    notifyListeners();
  }

  initPreference() async{
    if(localStorage == null){
      localStorage = await SharedPreferences.getInstance();
    }
  }

  loadLanguage() async {
    await initPreference();
    this._currentLocale = new Locale(localStorage.getString('lang'));
    this._currentLocaleName = localStorage.getString('langName');
    notifyListeners();
  }

  setLanguage(String lang, String langName) async {
    await initPreference();
    localStorage.setString('lang', lang);
    localStorage.setString('langName', langName);
  }

  changeLocale(String _locale, String _localeName){
    this._currentLocale = new Locale(_locale);
    this._currentLocaleName = _localeName;
    setLanguage(_locale, _localeName);
    notifyListeners();
  }

}