import 'package:flutter/material.dart';

import '../models/wine.dart';

class WineListScreen extends StatefulWidget {

  @override
  State<WineListScreen> createState() => _WineListScreenState();

}

class _WineListScreenState extends State<WineListScreen> {
  List<Wine> wines = WineBrain().wineList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wine List'),
      ),
      body: ListView.builder(
        itemCount: wines.length,
        itemBuilder: (context, index) {
          final wine = wines[index];

          return ListTile(
            title: Text(wine.name),
            subtitle: Text('Rating: ${wine.rating}'),
          );
        },
      ),
    );
  }
}