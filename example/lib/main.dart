import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

void main() {
  runApp(const MyApp());
}

final scaffoldKey = GlobalKey<ScaffoldMessengerState>();

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
      scaffoldMessengerKey: scaffoldKey,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ExpandableFab Examples')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Float FAB (default)'),
            subtitle: const Text('Standard floating action button position'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const FloatFabPage()),
            ),
          ),
          ListTile(
            title: const Text('Docked FAB'),
            subtitle: const Text('FAB docked in BottomAppBar'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DockedFabPage()),
            ),
          ),
        ],
      ),
    );
  }
}

class CounterWidget extends StatelessWidget {
  final _counter = ValueNotifier(0);

  CounterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}

// Float FAB example
class FloatFabPage extends StatefulWidget {
  const FloatFabPage({Key? key}) : super(key: key);

  @override
  State<FloatFabPage> createState() => _FloatFabPageState();
}

class _FloatFabPageState extends State<FloatFabPage> {
  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Float FAB')),
      body: CounterWidget(),
      floatingActionButtonLocation: ExpandableFab.float,
      floatingActionButton: ExpandableFab(
        key: _key,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.black.withValues(alpha: 0.5),
          blur: 5,
        ),
        onOpen: () => debugPrint('onOpen'),
        afterOpen: () => debugPrint('afterOpen'),
        onClose: () => debugPrint('onClose'),
        afterClose: () => debugPrint('afterClose'),
        children: [
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.edit),
            onPressed: () {
              const snackBar = SnackBar(content: Text('Edit pressed'));
              scaffoldKey.currentState?.showSnackBar(snackBar);
            },
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.search),
            onPressed: () {
              const snackBar = SnackBar(content: Text('Search pressed'));
              scaffoldKey.currentState?.showSnackBar(snackBar);
            },
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
    );
  }
}

// Docked FAB example
class DockedFabPage extends StatefulWidget {
  const DockedFabPage({Key? key}) : super(key: key);

  @override
  State<DockedFabPage> createState() => _DockedFabPageState();
}

class _DockedFabPageState extends State<DockedFabPage> {
  final _key = GlobalKey<ExpandableFabState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Docked FAB')),
      body: CounterWidget(),
      floatingActionButtonLocation: ExpandableFab.docked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: ExpandableFab(
        key: _key,
        pos: ExpandableFabPos.center,
        overlayStyle: ExpandableFabOverlayStyle(
          color: Colors.black.withValues(alpha: 0.5),
          blur: 5,
        ),
        onOpen: () => debugPrint('onOpen'),
        afterOpen: () => debugPrint('afterOpen'),
        onClose: () => debugPrint('onClose'),
        afterClose: () => debugPrint('afterClose'),
        children: [
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.edit),
            onPressed: () {
              const snackBar = SnackBar(content: Text('Edit pressed'));
              scaffoldKey.currentState?.showSnackBar(snackBar);
            },
          ),
          FloatingActionButton.small(
            heroTag: null,
            child: const Icon(Icons.search),
            onPressed: () {
              const snackBar = SnackBar(content: Text('Search pressed'));
              scaffoldKey.currentState?.showSnackBar(snackBar);
            },
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
    );
  }
}
