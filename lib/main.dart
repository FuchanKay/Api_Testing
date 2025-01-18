import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NasaData {
  final String date;
  final String explanation;
  final String? hdurl;
  final String media_type;
  final String service_version;
  final String title;
  final String? url;

  NasaData(
      {required this.date,
      required this.explanation,
      required this.hdurl,
      required this.media_type,
      required this.service_version,
      required this.title,
      required this.url});

  static Future<List<NasaData>> fetchNasaData() async {
    final response = await http.get(Uri.parse(
        'https://api.nasa.gov/planetary/apod?start_date=2005-09-23&end_date=2006-09-23&api_key=Gu4p8S9mFz35ctSZVzmr1dftPTyfpgBuqjBe7Q6y'));
    if (response.statusCode == 200) {
      // List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
      final returnValue = (jsonDecode(response.body) as List<dynamic>)
          .map((json) => NasaData.fromJson(json as Map<String, dynamic>))
          .toList();
      print("~~~~~~~~~~~~~~~~~~~~~~~~");
      returnValue.forEach((x) => print(x.hdurl));
      print("~~~~~~~~~~~~~~~~~~~~~~~~");

      return returnValue;
    } else {
      throw Exception("Failed to load NasaData");
    }
  }

  factory NasaData.fromJson(Map<String, dynamic> json) {
    return NasaData(
      date: json['date'] as String,
      explanation: json['explanation'] as String,
      hdurl: json['hdurl'] as String?,
      media_type: json['media_type'] as String,
      service_version: json['service_version'] as String,
      title: json['title'] as String,
      url: json['url'] as String?,
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<NasaData>> futureNasaData;

  @override
  void initState() {
    super.initState();
    futureNasaData = NasaData.fetchNasaData();
  }

  @override
  Widget build(BuildContext context) {
    print(futureNasaData);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Image from URL')),
        body: Center(
          child: Image.network(
            'https://example.com/your-image.jpg',
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            },
            errorBuilder:
                (BuildContext context, Object error, StackTrace? stackTrace) {
              return const Text('Failed to load image');
            },
          ),
        ),
      ),
    );
  }
}


// void main(){
//   final x = [5, 6, 7, 8, 9];

//   final y = x.map((e) => e * 2);

//   print(y);
// }