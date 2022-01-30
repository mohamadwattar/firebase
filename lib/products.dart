import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });
}

class Products with ChangeNotifier {
  List<Product> productsList = [
    Product(
      id: '998',
      title: 'Picture #998',
      description:
          'Officia cupidatat excepteur in duis. Nisi aliqua aliquip id dolor mollit anim exercitation non amet consequat occaecat culpa. Minim pariatur incididunt incididunt excepteur Lorem reprehenderit pariatur. Anim non consectetur do quis ut Lorem eu duis veniam magna non nulla. Lorem reprehenderit non dolore officia laborum officia dolore eu pariatur in. Magna ut consectetur cupidatat minim pariatur enim elit nulla voluptate culpa et aliqua aliquip incididunt.',
      price: 11,
      imageUrl:
          'https://i.pinimg.com/736x/0c/08/98/0c0898828f130249ea46b2c6f50ed909.jpg',
    ),
    Product(
      id: '999',
      title: 'Picture #999',
      description:
          'Reprehenderit esse mollit pariatur fugiat sit. Pariatur officia amet est nisi qui nostrud fugiat quis exercitation eiusmod qui eiusmod esse est. Pariatur adipisicing dolore nostrud laborum velit commodo sunt occaecat adipisicing. Dolor dolor aute enim ut dolor cupidatat ea Lorem ut exercitation mollit. Velit duis ullamco enim et pariatur veniam. Velit nostrud reprehenderit incididunt enim elit duis elit duis labore.',
      price: 34,
      imageUrl:
          'https://thumbs.dreamstime.com/b/autumn-fall-nature-scene-autumnal-park-beautiful-77869343.jpg',
    ),
  ];

  String? authToken;
  getData(String? authTok, List<Product> nnn) {
    authToken = authTok;
    productsList = nnn;
    notifyListeners();
  }

  Future<void> fetchData() async {
    try {
      var url = Uri.parse(
          'https://flutter-app-89385-default-rtdb.firebaseio.com/product.json?auth=$authToken');
      var res = await http.get(url);

      final extractedData = json.decode(res.body) as Map<String, dynamic>;
      extractedData.forEach((prodId, prodData) {
        var x =
            productsList.firstWhereOrNull(((element) => element.id == prodId));
        //var x = productsList.firstWhere(((element) => element.id == prodId),

        if (x == null) {
          productsList.add(Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl']));
        }
      });
      print('xxxxxxxxxxx==$authToken');
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateData(String id) async {
    try {
      final url = Uri.parse(
          'https://flutter-app-89385-default-rtdb.firebaseio.com/product/$id.json?auth=$authToken');
      final prodIndex = productsList.indexWhere((element) => element.id == id);
      if (prodIndex >= 0) {
        await http.patch(url,
            body: json.encode({
              'title': 'new title',
              'description': 'new description',
              'price': 'new price',
              'imageUrl': 'new imageUrl',
            }));

        notifyListeners();
      } else {
        print('...');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> add(
      {required String title,
      required String description,
      required double price,
      required String imageUrl}) async {
    try {
      var url = Uri.parse(
          'https://flutter-app-89385-default-rtdb.firebaseio.com/product.json?auth=$authToken');
      var res = await http.post(url,
          body: json.encode({
            'title': title,
            'description': description,
            'price': price,
            'imageUrl': imageUrl,
          }));

      print(json.decode(res.body));

      productsList.add(Product(
          id: json.decode(res.body)['name'],
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl));
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    final url = Uri.parse(
        'https://flutter-app-568d3.firebaseio.com/product/$id.json?auth=$authToken');

    final prodIndex = productsList.indexWhere((element) => element.id == id);
    var prodItem = productsList[prodIndex];
    productsList.removeAt(prodIndex);
    notifyListeners();

    var res = await http.delete(url);
  }
}
