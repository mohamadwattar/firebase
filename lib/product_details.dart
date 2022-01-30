import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'products.dart';

class ProductDetails extends StatelessWidget {
  final String id;

  const ProductDetails(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Product> prodList =
        Provider.of<Products>(context, listen: true).productsList;

    Product? filteredItem;
    try {
      filteredItem = prodList.firstWhere((Product element) => element.id == id);
    } catch (e) {
      filteredItem = null;
    }

    return Scaffold(
      appBar:
          AppBar(title: filteredItem == null ? null : Text(filteredItem.title)),
      body: SafeArea(
        child: filteredItem == null
            ? Container(height: 0)
            : ListView(
                children: [
                  const SizedBox(height: 10),
                  buildContainer(filteredItem.imageUrl, filteredItem.id),
                  const SizedBox(height: 10),
                  buildCard(filteredItem.title, filteredItem.description,
                      filteredItem.price),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue[900],
        onPressed: () {
          Navigator.pop(context, filteredItem!.id);
        },
        child: const Icon(Icons.delete, color: Colors.white),
      ),
    );
  }

  Widget buildContainer(String image, String id) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: Hero(
          tag: id,
          child: Image.network(image),
        ),
      ),
    );
  }

  Card buildCard(String title, String desc, double price) {
    return Card(
      elevation: 10,
      margin: const EdgeInsets.all(7),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(color: Colors.black),
            Text(desc,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.justify),
            const Divider(color: Colors.black),
            Text(
              '\$$price',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
