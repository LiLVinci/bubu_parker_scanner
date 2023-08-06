import 'dart:io';

class Wine {
  final String name;
  final int rating;
  final String maturity;
  final String vintage;

  Wine({required this.name, required this.rating, required this.vintage, required this.maturity});
}

class WineBrain {
  List<Wine> _wines = [];

  // Retrieve the list of wines. We'll use a getter to ensure the original list can't be modified.
  List<Wine> get wineList => _wines;

  void addWine(Wine wine) {
    _wines.add(wine);
  }

  // Function to fetch ratings from the web
  Future<Wine> fetchRating(String wineName) async {
    // Implement your function to scrape wine ratings here and return a Wine instance
    throw UnimplementedError();
  }
}