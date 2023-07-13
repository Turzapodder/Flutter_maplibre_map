import 'dart:convert';
import 'package:http/http.dart' as http;

class BarikoiAutocompleteService {
  Future<List<String>> getAutocompleteResults(String keyword) async {
    const apiKey = "NDc4NjpQMzJBVEJMWDY2";
    final url =
        "https://barikoi.xyz/v1/api/search/autocomplete/$apiKey/place?q=$keyword";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final List<dynamic> places = jsonResponse['places'];
        final List<String> suggestions = places.map((place) {
          final address = place['address'].toString();
          final area = place['area'].toString();
          return '$address| $area';
        }).toList();
        return suggestions;
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }
}
