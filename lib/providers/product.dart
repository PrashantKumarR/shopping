import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_shop/models/http_exception.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void toggleFavouriteStatus() async {
    final oldState = isFavourite;
    final url = 'https://flutter-shop-89706.firebaseio.com/products/$id.json';
    _setFavValue(!isFavourite);

    try {
      await http
          .patch(
        url,
        body: json.encode({
          'isFavourite': isFavourite,
        }),
      )
          .then((response) {
        if (response.statusCode >= 400) {
          throw HttpException('Failed to toggle favourite!');
        }
      });
    } catch (error) {
      _setFavValue(oldState);
    }
  }

  void _setFavValue(bool value) {
    isFavourite = value;
    notifyListeners();
  }
}
