import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyScreen(),
    );
  }
}

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  bool isGridView = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Layout Example'),
      ),
      body: isGridView ? buildGridView() : buildScrollView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isGridView = !isGridView;
          });
        },
        child: Icon(Icons.toggle_on),
      ),
    );
  }

  Widget buildScrollView() {
    return SingleChildScrollView(
      child: Column(
        children:
            List.generate(20, (index) => ListTile(title: Text('Item $index'))),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 20,
      itemBuilder: (context, index) => Card(
        child: Center(child: Text('Item $index')),
      ),
    );
  }
}
