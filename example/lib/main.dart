import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _counter = ValueNotifier(0);
  final _key = GlobalKey<ExpandableFabState>();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'You have pushed the button this many times:',
              ),
              ValueListenableBuilder(
                valueListenable: _counter,
                builder: (context, counter, _) {
                  return Text(
                    '$counter',
                    style: Theme.of(context).textTheme.displayMedium,
                  );
                },
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('add'),
                onPressed: () => _counter.value++,
              ),
            ],
          ),
        ),
        floatingActionButton: ExpandableFab(
          key: _key,
          // duration: const Duration(seconds: 1),
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
          overlayStyle: ExpandableFabOverlayStyle(
            color: Colors.black.withOpacity(0.5),
            // blur: 5,
          ),
          children: [
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.edit),
              onPressed: () {},
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.search),
              onPressed: () {},
            ),
            FloatingActionButton.small(
              heroTag: null,
              child: const Icon(Icons.share),
              onPressed: () {
                final state = _key.currentState;
                if (state != null) {
                  debugPrint('isOpen:${state.isOpen}');
                  state.toggle();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
