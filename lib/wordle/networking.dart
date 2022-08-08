import 'package:http/http.dart' as http;

Future<String> getTarget(http.Client client) async {
  var response = await client.get(Uri.https("181.127.68.241:443", "/get_target"));
  print(response.body);
  return response.body;
}

Future<bool> isValidGuess(http.Client client, String guess) async {
  String host = "192.168.0.19:8080";
  String path = "/is_valid_guess/$guess";
  var response = await client.get(Uri.http(host, path));
  if (response.body == "1") {
    return true;
  }

  return false;
}
