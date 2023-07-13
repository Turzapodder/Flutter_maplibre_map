import 'package:barikoi_maplibre_map/widgets/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:maplibre_gl/mapbox_gl.dart';
import 'package:location/location.dart';
import '../ServerUtilities/auto_complete.dart';
import '../ServerUtilities/nearby_banks.dart';
import '../ServerUtilities/reverse_geocoding.dart';
import '../models/bank_model.dart';
import '../utils/const.dart';
import '../widgets/bankInfoWindow.dart';

class MapPage2 extends StatefulWidget {
  const MapPage2({Key? key}) : super(key: key);

  @override
  _MapPage2State createState() => _MapPage2State();
}

class _MapPage2State extends State<MapPage2> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  LocationData? _currentLocation;
  final Location _location = Location();
  MaplibreMapController? _mapController;
  final TextEditingController _searchController = TextEditingController();
  BarikoiService _barikoiService = BarikoiService();
  String _currentLocationAddress = "";
  BarikoiAutocompleteService _autocompleteService = BarikoiAutocompleteService();
  List<String> _suggestions = [];
  bool _isSuggestionsVisible = false;
  List<Bank> _nearbyBanks = [];

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }
    permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      final location = await _location.getLocation();
      setState(() {
        _currentLocation = location;
      });

      if (_currentLocation != null) {
        final latitude = _currentLocation!.latitude!;
        final longitude = _currentLocation!.longitude!;
        final address = await _barikoiService.getAddress(latitude, longitude);
        setState(() {
          _currentLocationAddress = address;
        });

        _getNearbyBanks();
      }
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _getNearbyBanks() async {
    try {
      final banks = await fetchNearbyBanks(
          _currentLocation!.longitude!, _currentLocation!.latitude!);

      setState(() {
        _nearbyBanks = banks;
      });

      _nearbyBanks.forEach((bank) {
        final markerOptions = SymbolOptions(
            geometry: LatLng(bank.latitude, bank.longitude),
            iconSize: 0.25,
            iconImage: 'assets/images/bank.png',
            textField: bank.name,
            textSize: 12,
            textOffset: const Offset(0, -2.8));
        _mapController?.addSymbol(markerOptions);
      });
      _mapController?.onSymbolTapped.add((symbol) {
        print('Marker tapped: ${symbol.options.textField}');
        final bank = _nearbyBanks.firstWhere(
          (bank) =>
              bank.latitude == symbol.options.geometry?.latitude &&
              bank.longitude == symbol.options.geometry?.longitude,
        );
        _showBankInfoWindow(
            context, bank);
      });
    } catch (e) {
      print('Error fetching nearby banks: $e');
    }
  }

  void _showBankInfoWindow(BuildContext context, Bank bank) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: BankInfoWindow(bank: bank),
      ),
    );
  }

  void _goToCurrentLocation() {
    if (_mapController != null && _currentLocation != null) {
      final target =
          LatLng(_currentLocation!.latitude!, _currentLocation!.longitude!);
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(target, 14),
        duration: const Duration(seconds: 2),
      );
    }
  }

  Future<void> _getAutocompleteSuggestions(String keyword) async {
    if (keyword.isNotEmpty) {
      final suggestions =
          await _autocompleteService.getAutocompleteResults(keyword);
      setState(() {
        _suggestions = suggestions;
        _isSuggestionsVisible = true;
      });
    } else {
      setState(() {
        _suggestions = [];
        _isSuggestionsVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: _currentLocation != null
          ? SafeArea(
              child: Stack(
                children: [
                  MaplibreMap(
                    styleString: _mapStyleUrl(),
                    myLocationEnabled: true,
                    myLocationRenderMode: MyLocationRenderMode.COMPASS,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_currentLocation!.latitude!,
                          _currentLocation!.longitude!),
                      zoom: 14,
                    ),
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                    trackCameraPosition: true,
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: IconButton(
                                onPressed: () {
                                  _scaffoldKey.currentState!.openDrawer();
                                },
                                icon: const Icon(Icons.menu),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: _getAutocompleteSuggestions,
                                decoration: InputDecoration(
                                  hintText: _currentLocationAddress.isNotEmpty
                                      ? _currentLocationAddress
                                      : "Unknown",
                                  hintStyle: TextStyle(color: Colors.grey),
                                  suffixIcon: const Icon(
                                    Icons.location_on,
                                    color: primaryColor,
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  setState(() {
                                    _isSuggestionsVisible = _searchController
                                        .text
                                        .isNotEmpty; // Show the suggestions list on text field tap
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (_isSuggestionsVisible &&
                      _searchController.text.isNotEmpty)
                    Positioned(
                      top: 45.0, // Adjust the top position according to your UI
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Container(
                          height: 350,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ListView.separated(
                            itemCount: _suggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = _suggestions[index];
                              final address = suggestion.split('|')[0].trim();
                              final area = suggestion.split('|')[1].trim();
                              return ListTile(
                                leading: Icon(
                                  Icons.location_on_sharp,
                                  color: Colors.grey,
                                ),
                                title: Text(
                                  address,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.black54),
                                ),
                                subtitle: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3, horizontal: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: Text(
                                        area,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )),
                                ),
                                onTap: () {
                                  _searchController.text = _suggestions[index];
                                  setState(() {
                                    _suggestions = [];
                                  });
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.0),
                                child: Divider(
                                  color: secondaryColor40LightTheme,
                                  thickness: 0.4,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 16.0,
                    right: 16.0,
                    child: FloatingActionButton(
                      backgroundColor: secondaryColor20LightTheme,
                      onPressed: _goToCurrentLocation,
                      child: const Icon(
                        Icons.my_location,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : const SafeArea(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
      drawer:  Builder(
        builder: (context) => CustomDrawer(context),
      ),
    );
  }

  String _mapStyleUrl() {
    return "https://map.barikoi.com/styles/barikoi-bangla/style.json?key=$apiKey";
  }
}
