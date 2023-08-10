import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;
import '../models/wine.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:convert';

Future<List<Wine>> scrapeRating(wineName) async {
  final wines = <Wine>[];

  String url = "https://www.robertparker.com/search/wines?q=${wineName}";
  String encodedUrl = Uri.encodeFull(url);

  print(encodedUrl);

  final String content = await loadWebPage(url);

  print(content);

  var regex = RegExp(r'\\u([0-9a-fA-F]{4})');
  var decodedContent = content.replaceAllMapped(regex, (match) {
    var value = int.parse(match[1]!, radix: 16);
    return String.fromCharCode(value);
  });

  String cleanedContent = decodedContent.replaceAll('\\n', '').replaceAll('\\t', '').replaceAll('  ', ''); // removes extra spaces

  final document = parser.parse(cleanedContent);
  // #TODO: if there is no nice wine here present the winename again to edit it or redo the picture

  var table = document.querySelector('table');
  var rows = table?.querySelectorAll('tr');

  for (var row in rows!) {
    var cells = row.querySelectorAll('td');
    if (cells.length > 0) {
      var wineVintage = cells[1].text.trim();
      var wineName = cells[2].text.trim();
      var wineMaturity = cells[3].text.trim();
      var color = cells[4].text.trim();
      var wineRating = cells[5].text.trim();

      wineRating = wineRating.replaceAll("RP", "");
      int doubleRating = int.parse(wineRating);

      print('Vintage: $wineVintage, Wine Name: $wineName, Maturity: $wineMaturity, Color: $color, Rating: $wineRating');
      final wine = Wine(name: wineName, rating: doubleRating, maturity: wineMaturity, vintage: wineVintage);
      wines.add(wine);
    }
  }

  return wines;
}

Future<String> loadWebPage(String url) async {
  final flutterWebviewPlugin = FlutterWebviewPlugin();
  final Completer<String> completer = Completer<String>();

  print("LAUNCHING WEBVIEW");
  flutterWebviewPlugin.launch(url);
  bool loaded = false;
  String? content = await flutterWebviewPlugin.evalJavascript('document.documentElement.innerHTML');
  // #TODO: hide the webview and display a loading screen
  // #TODO: If the login is required show the webview to log in

  while (!loaded) {
    if (content != null && content.contains('site-wrappsdfsdfsder')) {
      loaded = true;
      print("POINTA");
      content = await flutterWebviewPlugin.evalJavascript("document.querySelector('.reactive-table-wrapper').innerHTML");
      debugPrint(content);
      completer.complete(content);
      print("LOOP FINISHED");
    } else {
      await Future.delayed(Duration(seconds: 1));
      // content = await flutterWebviewPlugin.evalJavascript('document.documentElement.innerHTML');
      content = await flutterWebviewPlugin.evalJavascript('document.documentElement.innerHTML');

      print("STARTING LOOP AGAIN");
      debugPrint(content);
    }
  }
  flutterWebviewPlugin.close();
  return completer.future;
}
