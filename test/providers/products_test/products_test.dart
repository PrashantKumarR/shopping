import 'package:flutter/cupertino.dart';
import 'package:flutter_shop/providers/product.dart';
import 'package:flutter_shop/providers/products.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class MockClient extends Mock implements http.Client {}
final client = MockClient();


void main() {
  group('fetchAndSetProducts', () {
    Products productProviders;
    setUp(() {
      productProviders = Products(client);
    });

    test('set a list of Products in ProductProvider when successful', () async {
      when(client
          .get('https://flutter-shop-89706.firebaseio.com/products.json'))
          .thenAnswer((_) async => http.Response(productResponseBodyStub, 200));

      await productProviders.fetchAndSetProducts();

      expect(productProviders.items.length, equals(2));
      expect(productProviders.items[0].id, equals(productList[0].id));
      expect(productProviders.items[0].title, equals(productList[0].title));
      expect(productProviders.items[0].description,
          equals(productList[0].description));
      expect(productProviders.items[0].price, equals(productList[0].price));
    });

    test('list of Products is empty when failed', () async {
      when(client
          .get('https://flutter-shop-89706.firebaseio.com/products.json'))
          .thenAnswer((_) async => http.Response('Not Found', 404));
      await productProviders.fetchAndSetProducts();

      expect(productProviders.items.length, equals(0));
    });

    test('list of Products is empty when exception throws', () async {
      when(client
          .get('https://flutter-shop-89706.firebaseio.com/products.json'))
          .thenThrow(Error());

      expect(
              () => productProviders.fetchAndSetProducts(), throwsA(isA<Error>()));
      expect(productProviders.items.length, equals(0));
    });

    test('list of Products is empty when no product found but API is succefful',
            () async {
          when(client
              .get('https://flutter-shop-89706.firebaseio.com/products.json'))
              .thenAnswer((_) async => http.Response('{}', 200));

          await productProviders.fetchAndSetProducts();

          expect(productProviders.items.length, equals(0));
        });
  });


  group('addProduct', () {
    Products productProviders;
    setUp(() {
      productProviders = Products(client);
    });

    test('a new product object is added if successful', () async {
      final newProduct = Product(
        title: "Gold Category",
        description: 'Worlds best product',
        imageUrl: 'not an image',
        isFavourite: true,
        price: 50000000.0,
      );
      when(client
          .post(any, body: anyNamed('body')))
          .thenAnswer((_) async => http.Response('{"name":"-helloWorld"}', 200));

      await productProviders.addProduct(newProduct);

      List<dynamic> capturedArguments =
          verify(client.post(captureAny, body: captureAnyNamed('body'))).captured;
      expect(
          capturedArguments[1], equals(jsonEncodedNewProductStub(newProduct)));
    });
  });

}


// >>>>>>>>>>>>>>>>>>>>>>>>>>> Test Double Starts Here >>>>>>>>>>>>>>>>>>>>>>>
final productList = [
  Product(
    id: '-M6OdJhKiUi7t660zvPc',
    title: "Cup",
    description: 'A very stylish and durable product',
    imageUrl: 'https://pngimg.com/uploads/cup/cup_PNG2004.png',
    isFavourite: true,
    price: 23.0,
  ),
  Product(
    id: '-M6P4iPNiOXPlLyN7gab',
    title: "Brown  New Cup",
    description: 'Blue Cup is good',
    imageUrl:
    'https://pluspng.com/img-png/cup-png-coffee-cup-png-transparent-image-1300.png',
    isFavourite: false,
    price: 23.0,
  ),
];

final productResponseBodyStub =
    '{"-M6OdJhKiUi7t660zvPc":{"description":"A very stylish and durable product","imageUrl":"https://pngimg.com/uploads/cup/cup_PNG2004.png","isFavourite":true,"price":23.0,"title":"Cup"},"-M6P4iPNiOXPlLyN7gab":{"description":"Blue Cup is good","imageUrl":"https://pluspng.com/img-png/cup-png-coffee-cup-png-transparent-image-1300.png","isFavourite":false,"price":23.0,"title":"Brown  New Cup"}}';

String jsonEncodedNewProductStub(Product product) {
  return json.encode({
    'title': product.title,
    'description': product.description,
    'imageUrl': product.imageUrl,
    'price': product.price,
    'isFavourite': product.isFavourite,
  });
}
// <<<<<<<<<<<<<<<<<<<<<<<<<< Test Double Ends Here <<<<<<<<<<<<<<<<<<<<<<<<<<

