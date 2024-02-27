class Constants {
  static String url = "http://192.168.1.4:6060/api";
  static dynamic contentType = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer '
  };

  static String setUrl(String endpoint) {
    return "$url/$endpoint";
  }
}
