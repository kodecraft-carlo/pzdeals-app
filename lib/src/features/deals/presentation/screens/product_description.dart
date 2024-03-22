import 'package:flutter/material.dart';

class ProductDescriptionWidget extends StatelessWidget {
  const ProductDescriptionWidget({
    super.key,
    required this.description,
  });

  final Widget description;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text('Product Description'),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: FilledButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => Dialog(
                        // title: const Text('Product Description'),
                        child: description,
                        // actions: [
                        //   TextButton(
                        //     onPressed: () {
                        //       Navigator.of(context).pop();
                        //     },
                        //     child: const Text('Close'),
                        //   ),
                        // ],
                      ));
            },
            child: const Text('Show Dialog'),
          )),
    ));
  }
}
