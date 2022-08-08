import 'package:http/http.dart' as http;

Future<String> getTarget(http.Client client) async {
  var response = await client.get(Uri.https("marcosrene.ga", "/get_target"));
  print(response.body);
  return response.body;
}

Future<bool> isValidGuess(http.Client client, String guess) async {
  String host = "marcosrene.ga";
  String path = "/is_valid_guess/$guess";
  var response = await client.get(Uri.http(host, path));
  if (response.body == "1") {
    return true;
  }

  return false;
}
