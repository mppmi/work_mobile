import 'dart:developer';
import 'package:flutter_application_2/models/respone/trips_idx_get_res.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_application_2/config/config.dart';

class TripPage extends StatefulWidget {
  // Atribute of TripPage
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  late TripIdxGetResponse trip;
  late Future<void> loadData;
  String url = '';

  @override
  void initState() {
    //TODO: implement initSrate
    super.initState();
    log(widget.idx.toString());
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดทริป'),
      ),
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          // Loading...
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  trip.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(trip.country),
                Image.network(trip.coverimage),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('ราคา ${trip.price.toString()} บาท'),
                    Text(trip.destinationZone)
                  ],
                ),
                Text(trip.detail),
                Center(
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text('จองทริปนี้'),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // Async function for api call
  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndpoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body);
    trip = tripIdxGetResponseFromJson(res.body);
  }
}