import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static String? userId;
  static String? userPhone;
  static String? userOtp;

  var time = DateTime;

  static Future<SharedPreferences> get _instance async =>
      _prefsInstance ??= await SharedPreferences.getInstance();
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences> init() async {
    _prefsInstance = await _instance;
    return _prefsInstance!;
  }

  static String? getString(String? key, [String? defValue]) {
    if (PreferenceUtils._prefsInstance != null) {
      return _prefsInstance!.getString(key!) ?? defValue ?? "";
    }
    return null;
  }

  // static bool containsKey(String key, [bool? defValue]){
  //  if(PreferenceUtils._prefsInstance != null){
  //   return _prefsInstance!.containsKey(key);
  //  }
  //  else{
  //   return true;
  //  }
  // }

  static Future<bool> setString(String key, String value) async {
    var prefs = await _instance;

    return prefs.setString(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async{
    var prefs = await _instance;

    return prefs.setStringList(key, value);

  }

  // Saving a product to display in the cart
  static int totalProductsInTheCart = 0;
  static addToCart(String productName, int price) async {
    totalProductsInTheCart++;
    
  }


  // static Future<bool> setBool(String key, bool value) async {
  //   var prefs = await _instance;
  //   return prefs.setBool(key, value);
  // }

  // static bool? getBool(String key, [bool? defValue]) {
  //   return _prefsInstance!.getBool(key) ?? defValue ?? false;
  // }

  // static Future<bool> setInt(String key, int value) async {
  //   var prefs = await _instance;

  //   return prefs.setInt(key, value);
  // }

  // static int getInt(String key, [int? defValue]) {
  //   return _prefsInstance!.getInt(key) ?? defValue ?? 0;
  // }

  // static clearPreferences() {
  //   _prefsInstance!.clear();
  // }

  // static Future<bool> setDouble(String key, double value) async {
  //   var prefs = await _instance;
  //   return prefs.setDouble(key, value);
  // }

  // static double getDouble(String key, [double? defValue]) {
  //   return _prefsInstance!.getDouble(key) ?? defValue ?? 0;
  // }
}
