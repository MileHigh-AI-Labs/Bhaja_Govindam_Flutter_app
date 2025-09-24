import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'model/shloka_model.dart'; // Ensure this path is correct
import 'shloka_detail_screen.dart'; // Import the detail screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bhaja Govindam'),
        ),
        body: FutureBuilder<List<Shloka>>(
          future: loadShlokas(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final shlokas = snapshot.data!;
              return ListView.builder(
                itemCount: shlokas.length,
                itemBuilder: (context, index) {
                  final shloka = shlokas[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListTile(
                      title: Text(shloka.solkaNo),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShlokaDetailScreen(shloka: shloka),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('No data found.'));
            }
          },
        ),
      ),
    );
  }
}

Future<List<Shloka>> loadShlokas() async {
  final String jsonString = await rootBundle.loadString('assets/bhaja_govindam.json');
  final List<dynamic> jsonList = jsonDecode(jsonString);
  return jsonList.map((json) => Shloka.fromJson(json)).toList();
}