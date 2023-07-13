import 'dart:convert';
import 'package:http/http.dart' as http;

class BarikoiService {
  Future<String> getAddress(double latitude, double longitude) async {
    const apiKey = "NDc4NjpQMzJBVEJMWDY2";
    final url = "https://barikoi.xyz/v1/api/search/reverse/geocode/server/$apiKey/place?longitude=$longitude&latitude=$latitude&district=true&post_code=true&country=true&sub_district=true&union=true&pauroshova=true&location_type=true&division=true&address=true&area=true";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final address = jsonResponse["place"]["address"];
        return address;
      } else {
        print("Error: ${response.statusCode}");
        return "Unknown";
      }
    } catch (e) {
      print("Error: $e");
      return "Unknown";
    }
  }
}
