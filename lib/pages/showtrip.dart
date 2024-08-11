import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/config/internal_config.dart';
import 'package:flutter_application_2/models/respone/trip_get_res.dart';
import 'package:flutter_application_2/pages/login.dart';
import 'package:flutter_application_2/pages/profile.dart';
import 'package:flutter_application_2/pages/trip.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_2/config/config.dart';

class ShowTripPage extends StatefulWidget {
  int idx = 0;
  ShowTripPage({super.key, required this.idx});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  List<TripGetResponse> trips = [];
  late Future<void> loadData;
  String url = '';

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(idx: widget.idx),
                  ),
                );
              } else if (value == 'logout') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ปลายทาง'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  FilledButton(
                    onPressed: () => getTrip(null),
                    child: const Text('ทั้งหมด'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: () => getTrip('เอเชีย'),
                    child: const Text('เอเชีย'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: () => getTrip('ยุโรป'),
                    child: const Text('ยุโรป'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: () => getTrip('เอเชียตะวันออกเฉียงใต้'),
                    child: const Text('อาเซียน'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: () => getTrip('ประเทศไทย'),
                    child: const Text('ประเทศไทย'),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder(
                  future: loadData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      children: trips.map((trip) {
                        return Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  trip.name,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 160,
                                      height: 160,
                                      child: Image.network(
                                        trip.coverimage,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Center(
                                            child: Text(
                                              'cannot load image',
                                              textAlign: TextAlign.center,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            trip.country,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            'ระยะเวลา ${trip.duration} วัน',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          Text(
                                            'ราคา ${trip.price} บาท',
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          FilledButton(
                                            onPressed: () =>
                                                goToTripPage(trip.idx),
                                            child: const Text(
                                              'รายละเอียดเพิ่มเติม',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadDataAsync() async {
    await Future.delayed(const Duration(seconds: 2));
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];
    var data = await http.get(Uri.parse('$url/trips'));
    trips = tripGetResponseFromJson(data.body);
  }

 void getTrip(String? zone) {
    http.get(Uri.parse('$url/trips')).then(
      (value) {
        trips = tripGetResponseFromJson(value.body);
        List<TripGetResponse> filteredTrips = [];
        if (zone != null) {
          for (var trip in trips) {
            if (trip.destinationZone == destinationZoneValues.map[zone]) {
              filteredTrips.add(trip);
            }
          }
          trips = filteredTrips;
        }
        setState(() {});
      },
    ).catchError((err) {
      log(err.toString());
    });
}

  void goToTripPage(int idx) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripPage(idx: idx),
      ),
    );
  }
}
