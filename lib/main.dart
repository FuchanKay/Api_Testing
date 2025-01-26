import 'dart:math';

import 'package:api_testing/NasaData.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<NasaData> futureNasaData = [];
  static List<String?> urlList = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    retrieveData();
    print("future nasa data: ");
    print(futureNasaData);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Image from URL')),
        body: Center(
            child: Column(
          children: [
            // NasaImage(url: ""),
            Expanded(
              child: ListView.builder(
                  itemCount: urlList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      // child: NasaImage(url: urlList[index]),
                      child: NasaImage(url: ""),
                    );
                  }),
            )
          ],
        )),
      ),
    );
  }

  retrieveData() {
WidgetsBinding.instance.addPostFrameCallback((_) async {    
futureNasaData = await NasaData.fetchNasaData();
});
    //futureNasaData = await NasaData.fetchNasaData();
  }
}

class NasaImage extends StatelessWidget {
  final String? url;
  const NasaImage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    const nonNullUrl =
        "https://www.wikipedia.org/portal/wikipedia.org/assets/img/Wikipedia-logo-v2@1.5x.png" ??
            "url not found";
    return Image.network(
      nonNullUrl,
      fit: BoxFit.fill,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }
}

// class NasaImage extends StatelessWidget {
//   final String? url;
//   const NasaImage({super.key, required this.url});

//   @override
//   Widget build(BuildContext context) {
//     final nonNullUrl = url ?? "url not found";  
//     return Image.network(
//       nonNullUrl,
//       loadingBuilder: (BuildContext context, Widget child,
//           ImageChunkEvent? loadingProgress) {
//         if (loadingProgress == null) {
//           return child;
//         }
//         return Center(
//           child: CircularProgressIndicator(
//             value: loadingProgress.expectedTotalBytes != null
//                 ? loadingProgress.cumulativeBytesLoaded /
//                     (loadingProgress.expectedTotalBytes ?? 1)
//                 : null,
//           ),
//         );
//       },
//       errorBuilder:
//           (BuildContext context, Object error, StackTrace? stackTrace) {
//         return const Text('Failed to load image');
//       },
//     );
//   }
