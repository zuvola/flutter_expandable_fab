import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: Scaffold(
        body: const SizedBox.shrink(),
        floatingActionButton: ExpandableFab(
          // distance: 60.0,
          // type: ExpandableFabType.up,
          // fanAngle: 70,
          // child: const Icon(Icons.account_box),
          // foregroundColor: Colors.amber,
          // backgroundColor: Colors.green,
          // closeButtonStyle: const ExpandableFabCloseButtonStyle(
          //   child: Icon(Icons.abc),
          //   foregroundColor: Colors.deepOrangeAccent,
          //   backgroundColor: Colors.lightGreen,
          // ),
          children: [
            FloatingActionButton.small(
              child: const Icon(Icons.edit),
              onPressed: () {},
            ),
            FloatingActionButton.small(
              child: const Icon(Icons.search),
              onPressed: () {},
            ),
            FloatingActionButton.small(
              child: const Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
