import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NasaData {
  final String date;
  final String explanation;
  final String hdurl;
  final String media_type;
  final String service_version;
  final String title;
  final String url;

  NasaData(
      {required this.date,
      required this.explanation,
      required this.hdurl,
      required this.media_type,
      required this.service_version,
      required this.title,
      required this.url});

  static Future<NasaData> fetchNasaData() async {
    final response = await http.get(Uri.parse(
        'https://api.nasa.gov/planetary/apod?start_date=2005-09-23&end_date=2006-09-23&api_key=Gu4p8S9mFz35ctSZVzmr1dftPTyfpgBuqjBe7Q6y'));
    if ((response.statusCode == 200)) {
      return NasaData.fromJson(
          jsonDecode(response.body) as List<Map<String, dynamic>>);
    } else {
      throw Exception("Failed");
    }
  }

  factory NasaData.fromJson(List<Map<String, dynamic>> json) {
    return switch (json) {
      {
        'date': String date,
        'explanation': String explanation,
        'hdurl': String hdurl,
        'media_type': String media_type,
        'service_version': String service_version,
        'title': String title,
        'url': String url,
      } =>
        NasaData(
          date: date,
          explanation: explanation,
          hdurl: hdurl,
          media_type: media_type,
          service_version: service_version,
          title: title,
          url: url,
        ),
      _ => throw const FormatException('Failed to load NasaData.'),
    };
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
  late Future<NasaData> futureNasaData;

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
