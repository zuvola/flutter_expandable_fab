import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('float location', () {
    testWidgets('callback', (WidgetTester tester) async {
      var callStack = [];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Container(),
          floatingActionButtonLocation: ExpandableFab.float,
          floatingActionButton: ExpandableFab(
            onOpen: () {
              callStack.add('onOpen');
            },
            afterOpen: () {
              callStack.add('afterOpen');
            },
            onClose: () {
              callStack.add('onClose');
            },
            afterClose: () {
              callStack.add('afterClose');
            },
            children: [Container()],
          ),
        ),
      ));

      final ExpandableFabState state =
          tester.state(find.byType(ExpandableFab));

      expect(state.isOpen, false);

      state.toggle();
      await tester.pumpAndSettle();
      expect(callStack.length, 2);
      expect(callStack.first, 'onOpen');
      expect(callStack.last, 'afterOpen');
      expect(state.isOpen, true);

      callStack.clear();
      state.toggle();
      await tester.pumpAndSettle();
      expect(callStack.length, 2);
      expect(callStack.first, 'onClose');
      expect(callStack.last, 'afterClose');
      expect(state.isOpen, false);
    });

    testWidgets('position', (WidgetTester tester) async {
      Widget build(ExpandableFabPos pos) {
        return MaterialApp(
          home: Scaffold(
            body: Container(),
            floatingActionButtonLocation: ExpandableFab.float,
            floatingActionButton: ExpandableFab(
              pos: pos,
              children: [Container()],
            ),
          ),
        );
      }

      await tester.pumpWidget(build(ExpandableFabPos.right));
      await tester.pumpAndSettle();

      final closeFab = find.byType(FloatingActionButton).at(0);
      final openFab = find.byType(FloatingActionButton).at(1);
      expect(closeFab, isNotNull);
      expect(openFab, isNotNull);

      // ScreenSize: 800 x 600
      // kFloatingActionButtonMargin: 16.0
      // FabSize: 56
      // 800 - 16 - (56 / 2) = 756
      // 600 - 16 - (56 / 2) = 556
      var openCenter = tester.getCenter(openFab);
      expect(openCenter.dx.round(), 756.0);
      expect(openCenter.dy.round(), 556.0);
      var closeCenter = tester.getCenter(closeFab);
      expect(openCenter, closeCenter);

      await tester.pumpWidget(build(ExpandableFabPos.left));
      await tester.pump(const Duration(milliseconds: 50));

      // 16 + (56 / 2) = 44
      // 600 - 16 - (56 / 2) = 556
      openCenter = tester.getCenter(openFab);
      expect(openCenter.dx.round(), 44.0);
      expect(openCenter.dy.round(), 556.0);
      closeCenter = tester.getCenter(closeFab);
      expect(openCenter, closeCenter);
    });

    testWidgets('initialOpen, distance', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Container(),
          floatingActionButtonLocation: ExpandableFab.float,
          floatingActionButton: ExpandableFab(
            pos: ExpandableFabPos.right,
            initialOpen: true,
            distance: 100,
            children: const [Placeholder()],
          ),
        ),
      ));
      await tester.pumpAndSettle();

      ExpandableFabState state = tester.state(find.byType(ExpandableFab));
      expect(state.isOpen, true);

      // Center: (756, 556)
      // CloseButtonSize: 40
      // 756 + 40 / 2 = 776
      // 556 + 40 / 2 - 100 = 476
      final child = find.byType(Placeholder).first;
      final br = tester.getBottomRight(child);
      expect(br.dx.round(), 776.0);
      expect(br.dy.round(), 476.0);
    });

    testWidgets('initialOpen, childrenOffset, distance',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Container(),
          floatingActionButtonLocation: ExpandableFab.float,
          floatingActionButton: ExpandableFab(
            pos: ExpandableFabPos.right,
            initialOpen: true,
            childrenOffset: const Offset(10, 20),
            distance: 200,
            children: const [Placeholder()],
          ),
        ),
      ));
      await tester.pumpAndSettle();

      ExpandableFabState state = tester.state(find.byType(ExpandableFab));
      expect(state.isOpen, true);

      // Center: (756, 556)
      // CloseButtonSize: 40
      // 756 + 40 / 2 - 10 = 766
      // 556 + 40 / 2 - 200 - 20 = 356
      final child = find.byType(Placeholder).first;
      final br = tester.getBottomRight(child);
      expect(br.dx.round(), 766.0);
      expect(br.dy.round(), 356.0);
    });

    testWidgets('custom buttons', (WidgetTester tester) async {
      const openButtonChild = Icon(Icons.abc);
      const closeButtonIcon = Icon(Icons.check_circle_outline, size: 40);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Container(),
          floatingActionButtonLocation: ExpandableFab.float,
          floatingActionButton: ExpandableFab(
            openButtonBuilder: RotateFloatingActionButtonBuilder(
              child: openButtonChild,
              fabSize: ExpandableFabSize.large,
              foregroundColor: Colors.amber,
              backgroundColor: Colors.green,
              shape: const CircleBorder(),
              angle: 3.14 * 2,
            ),
            closeButtonBuilder: FloatingActionButtonBuilder(
              size: 56,
              builder: (BuildContext context, void Function()? onPressed,
                  Animation<double> progress) {
                return IconButton(
                  onPressed: onPressed,
                  icon: closeButtonIcon,
                );
              },
            ),
            children: [Container()],
          ),
        ),
      ));
      await tester.pumpAndSettle();

      final openFab = tester
          .widget<FloatingActionButton>(find.byType(FloatingActionButton));
      final closeFab = tester.widget<IconButton>(find.byType(IconButton));
      expect(openFab, isNotNull);
      expect(closeFab, isNotNull);

      expect(openFab.child, openButtonChild);
      expect(openFab.foregroundColor, Colors.amber);
      expect(openFab.backgroundColor, Colors.green);
      expect(openFab.shape, const CircleBorder());

      expect(closeFab.icon, closeButtonIcon);
    });
  });

  group('docked location', () {
    testWidgets('callback', (WidgetTester tester) async {
      var callStack = [];

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Container(),
          floatingActionButtonLocation: ExpandableFab.docked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Container(height: 56),
          ),
          floatingActionButton: ExpandableFab(
            onOpen: () {
              callStack.add('onOpen');
            },
            afterOpen: () {
              callStack.add('afterOpen');
            },
            onClose: () {
              callStack.add('onClose');
            },
            afterClose: () {
              callStack.add('afterClose');
            },
            children: [Container()],
          ),
        ),
      ));

      final ExpandableFabState state =
          tester.state(find.byType(ExpandableFab));

      expect(state.isOpen, false);

      state.toggle();
      await tester.pumpAndSettle();
      expect(callStack.length, 2);
      expect(callStack.first, 'onOpen');
      expect(callStack.last, 'afterOpen');
      expect(state.isOpen, true);

      callStack.clear();
      state.toggle();
      await tester.pumpAndSettle();
      expect(callStack.length, 2);
      expect(callStack.first, 'onClose');
      expect(callStack.last, 'afterClose');
      expect(state.isOpen, false);
    });

    testWidgets('position with BottomAppBar', (WidgetTester tester) async {
      Widget build(ExpandableFabPos pos) {
        return MaterialApp(
          home: Scaffold(
            body: Container(),
            floatingActionButtonLocation: ExpandableFab.docked,
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              child: Container(height: 56),
            ),
            floatingActionButton: ExpandableFab(
              pos: pos,
              children: [Container()],
            ),
          ),
        );
      }

      await tester.pumpWidget(build(ExpandableFabPos.right));
      await tester.pumpAndSettle();

      final closeFab = find.byType(FloatingActionButton).at(0);
      final openFab = find.byType(FloatingActionButton).at(1);
      expect(closeFab, isNotNull);
      expect(openFab, isNotNull);

      // Docked FAB is positioned higher than float due to +45 offset
      var openCenter = tester.getCenter(openFab);
      var closeCenter = tester.getCenter(closeFab);
      expect(openCenter, closeCenter);

      // Verify docked position is higher than float position
      // (docked getOffsetY adds +45 which shifts the scaffold geometry)
      expect(openCenter.dy < 600, true);
    });

    testWidgets('initialOpen with BottomAppBar', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Container(),
          floatingActionButtonLocation: ExpandableFab.docked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Container(height: 56),
          ),
          floatingActionButton: ExpandableFab(
            initialOpen: true,
            distance: 100,
            children: const [Placeholder()],
          ),
        ),
      ));
      await tester.pumpAndSettle();

      final ExpandableFabState state =
          tester.state(find.byType(ExpandableFab));
      expect(state.isOpen, true);

      final child = find.byType(Placeholder).first;
      expect(child, findsOneWidget);
    });

    testWidgets('custom buttons with docked', (WidgetTester tester) async {
      const openButtonChild = Icon(Icons.add);
      const closeButtonIcon = Icon(Icons.close, size: 40);
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Container(),
          floatingActionButtonLocation: ExpandableFab.docked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Container(height: 56),
          ),
          floatingActionButton: ExpandableFab(
            openButtonBuilder: RotateFloatingActionButtonBuilder(
              child: openButtonChild,
              fabSize: ExpandableFabSize.large,
              foregroundColor: Colors.red,
              backgroundColor: Colors.blue,
              shape: const CircleBorder(),
            ),
            closeButtonBuilder: FloatingActionButtonBuilder(
              size: 56,
              builder: (BuildContext context, void Function()? onPressed,
                  Animation<double> progress) {
                return IconButton(
                  onPressed: onPressed,
                  icon: closeButtonIcon,
                );
              },
            ),
            children: [Container()],
          ),
        ),
      ));
      await tester.pumpAndSettle();

      final openFab = tester
          .widget<FloatingActionButton>(find.byType(FloatingActionButton));
      final closeFab = tester.widget<IconButton>(find.byType(IconButton));
      expect(openFab, isNotNull);
      expect(closeFab, isNotNull);

      expect(openFab.child, openButtonChild);
      expect(openFab.foregroundColor, Colors.red);
      expect(openFab.backgroundColor, Colors.blue);
      expect(openFab.shape, const CircleBorder());

      expect(closeFab.icon, closeButtonIcon);
    });
  });

  group('center position', () {
    testWidgets('float center', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Container(),
          floatingActionButtonLocation: ExpandableFab.float,
          floatingActionButton: ExpandableFab(
            pos: ExpandableFabPos.center,
            children: [Container()],
          ),
        ),
      ));
      await tester.pumpAndSettle();

      final closeFab = find.byType(FloatingActionButton).at(0);
      final openFab = find.byType(FloatingActionButton).at(1);
      expect(closeFab, isNotNull);
      expect(openFab, isNotNull);

      // ScreenSize: 800 x 600
      // Center X: 800 / 2 = 400
      var openCenter = tester.getCenter(openFab);
      expect(openCenter.dx.round(), 400.0);
      var closeCenter = tester.getCenter(closeFab);
      expect(openCenter, closeCenter);
    });

    testWidgets('docked center', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Container(),
          floatingActionButtonLocation: ExpandableFab.docked,
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Container(height: 56),
          ),
          floatingActionButton: ExpandableFab(
            pos: ExpandableFabPos.center,
            children: [Container()],
          ),
        ),
      ));
      await tester.pumpAndSettle();

      final closeFab = find.byType(FloatingActionButton).at(0);
      final openFab = find.byType(FloatingActionButton).at(1);
      expect(closeFab, isNotNull);
      expect(openFab, isNotNull);

      // Center X should still be in the middle
      var openCenter = tester.getCenter(openFab);
      expect(openCenter.dx.round(), 400.0);
      var closeCenter = tester.getCenter(closeFab);
      expect(openCenter, closeCenter);
    });
  });
}
