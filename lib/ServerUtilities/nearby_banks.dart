

import 'dart:convert';
import '../models/bank_model.dart';
import '../utils/const.dart';
import 'package:http/http.dart' as http;

Future<List<Bank>> fetchNearbyBanks(double longitude, double latitude) async {
  final url = Uri.parse(
      'https://barikoi.xyz/v2/api/search/nearby/category/$apiKey/1/10?longitude=$longitude&latitude=$latitude&ptype=bank');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResult = json.decode(response.body);

    final places = jsonResult['places'] as List<dynamic>;

    return places.map<Bank>((place) {
      return Bank(
        id: place['id'],
        name: place['name'],
        distance: place['distance_in_meters'].toDouble(),
        longitude: place['longitude'].toDouble(),
        latitude: place['latitude'].toDouble(),
        address: place['Address'],
        city: place['city'],
        area: place['area'],
        pType: place['pType'],
        subType: place['subType'],
        uCode: place['uCode'],
      );
    }).toList();
  } else {
    throw Exception('Failed to fetch nearby banks');
  }
}
