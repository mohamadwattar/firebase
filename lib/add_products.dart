import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'products.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController imageUrlCont = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    const SizedBox(height: 10),
                    _textField('Title', 'Add Title', titleController),
                    const SizedBox(height: 10),
                    _textField(
                        'Description', 'Add Description', descController),
                    const SizedBox(height: 10),
                    _textField('Price', 'Add Price', priceController),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.blueAccent),
                    const SizedBox(height: 10),
                    _textField(
                        'Image Url', 'Paste your image url here', imageUrlCont),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.blueAccent),
                    Consumer<Products>(
                      builder: (ctx, value, _) => ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.lightBlue[900]),
                          ),
                          child: const Text('Submit'),
                          onPressed: () async {
                            if (titleController.text.isEmpty ||
                                descController.text.isEmpty ||
                                priceController.text.isEmpty ||
                                imageUrlCont.text.isEmpty) {
                              Fluttertoast.showToast(
                                  msg: 'Please enter all Fields',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else if (double.tryParse(priceController.text) ==
                                null) {
                              Fluttertoast.showToast(
                                  msg: 'Please enter a valid price',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              setState(() {
                                _isLoading = true;
                              });
                              try {
                                await value.add(
                                  title: titleController.text,
                                  description: descController.text,
                                  price: double.tryParse(priceController.text)!,
                                  imageUrl: imageUrlCont.text,
                                );
                              } catch (_) {
                                return showDialog<void>(
                                    context: context,
                                    builder: (innerContext) => AlertDialog(
                                          title:
                                              const Text('an error occurred'),
                                          content: const Text(
                                              'something went wrong'),
                                          actions: [
                                            ElevatedButton(
                                                child: const Text('okay'),
                                                onPressed: () =>
                                                    Navigator.of(innerContext)
                                                        .pop())
                                          ],
                                        ));
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });

                                Navigator.of(context).pop();
                              }
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _textField(String title, String desc, controller) {
    return Platform.isIOS
        ? CupertinoTextField(
            placeholder: title,
            placeholderStyle: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
            controller: controller,
          )
        : TextField(
            decoration: InputDecoration(
              labelText: title,
              hintText: desc,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
              hintStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.4),
              ),
            ),
            controller: controller,
          );
  }
}
