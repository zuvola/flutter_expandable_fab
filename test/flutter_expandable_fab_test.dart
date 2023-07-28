import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('callback', (WidgetTester tester) async {
    var callStack = [];

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Container(),
        floatingActionButtonLocation: ExpandableFab.location,
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

    final ExpandableFabState state = tester.state(find.byType(ExpandableFab));

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
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: ExpandableFab(
            pos: pos,
            children: [Container()],
          ),
        ),
      );
    }

    await tester.pumpWidget(build(ExpandableFabPos.right));
    await tester.pump(const Duration(milliseconds: 50));

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

  testWidgets('initialOpen, childrenOffset, distance',
      (WidgetTester tester) async {
    Widget build(ExpandableFabPos pos, double distance, Offset offset) {
      return MaterialApp(
        home: Scaffold(
          body: Container(),
          floatingActionButtonLocation: ExpandableFab.location,
          floatingActionButton: ExpandableFab(
            pos: pos,
            initialOpen: true,
            childrenOffset: offset,
            distance: distance,
            children: const [Placeholder()],
          ),
        ),
      );
    }

    // Distance: 100, Offset: 0
    await tester.pumpWidget(build(ExpandableFabPos.right, 100, Offset.zero));
    await tester.pump(const Duration(milliseconds: 50));

    ExpandableFabState state = tester.state(find.byType(ExpandableFab));
    expect(state.isOpen, true);

    // Center: (756, 556)
    // CloseButtonSize: 40
    // 756 + 40 / 2 = 776
    // 556 + 40 / 2 - 100 = 476
    var child = find.byType(Placeholder).first;
    var br = tester.getBottomRight(child);
    expect(br.dx.round(), 776.0);
    expect(br.dy.round(), 476.0);

    // Distance: 100, Offset: (10, 20)
    await tester.pumpWidget(build(
      ExpandableFabPos.right,
      200,
      const Offset(10, 20),
    ));
    await tester.pump(const Duration(milliseconds: 50));

    // 756 + 40 / 2 - 10 = 766
    // 556 + 40 / 2 - 200 - 20 = 356
    child = find.byType(Placeholder).first;
    br = tester.getBottomRight(child);
    expect(br.dx.round(), 766.0);
    expect(br.dy.round(), 356.0);
  });

  testWidgets('custom buttons', (WidgetTester tester) async {
    const openButtonChild = Icon(Icons.abc);
    const closeButtonIcon = Icon(Icons.check_circle_outline, size: 40);
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: Container(),
        floatingActionButtonLocation: ExpandableFab.location,
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
    await tester.pump(const Duration(milliseconds: 50));

    final openFab =
        tester.widget<FloatingActionButton>(find.byType(FloatingActionButton));
    final closeFab = tester.widget<IconButton>(find.byType(IconButton));
    expect(openFab, isNotNull);
    expect(closeFab, isNotNull);

    expect(openFab.child, openButtonChild);
    expect(openFab.foregroundColor, Colors.amber);
    expect(openFab.backgroundColor, Colors.green);
    expect(openFab.shape, const CircleBorder());

    expect(closeFab.icon, closeButtonIcon);
  });
}
