import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

class NasaData {
  static const String KEY = "Gu4p8S9mFz35ctSZVzmr1dftPTyfpgBuqjBe7Q6y";

  NasaData(
      {required this.date,
      required this.explanation,
      required this.hdurl,
      required this.media_type,
      required this.service_version,
      required this.title,
      required this.url});

  final String date;
  final String explanation;
  final String? hdurl;
  final String media_type;
  final String service_version;
  final String title;
  final String? url;

  static Future<List<NasaData>> fetchNasaData() async {
    final response = await http.get(Uri.parse(
        'https://api.nasa.gov/planetary/apod?start_date=2005-09-23&end_date=2005-09-25&api_key=$KEY'));
    print(response.statusCode);
    print(response.body);
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
