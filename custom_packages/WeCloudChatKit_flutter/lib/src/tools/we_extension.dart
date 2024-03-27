extension MapExtension on Map {
  bool boolValue(String key) {
    if (!containsKey(key)) {
      return false;
    } else if (this[key] is int) {
      return this[key] == 0 ? false : true;
    } else if (this[key] is String) {
      return this[key].toString().length == 0 ? false : true;
    } else if (this[key] is bool) {
      return this[key];
    } else {
      return false;
    }
  }
}
