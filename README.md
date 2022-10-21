# flutter_expandable_fab

[![pub package](https://img.shields.io/pub/v/flutter_expandable_fab.svg)](https://pub.dartlang.org/packages/flutter_expandable_fab)


**[English](https://github.com/zuvola/flutter_expandable_fab/blob/master/README.md), [日本語](https://github.com/zuvola/flutter_expandable_fab/blob/master/README_jp.md)**


`flutter_expandable_fab` is the speed dial FAB that can show/hide multiple action buttons with animation.  
This is an extension of the code in this article.  
https://docs.flutter.dev/cookbook/effects/expandable-fab


### Fan style & Blur overlay

<img src="https://github.com/zuvola/flutter_expandable_fab/blob/master/example/ss/fan.gif?raw=true" width="320px"/>

### Vertical style & Color overlay

<img src="https://github.com/zuvola/flutter_expandable_fab/blob/master/example/ss/up.gif?raw=true" width="320px"/>

### Horizontal style & Custom buttons

<img src="https://github.com/zuvola/flutter_expandable_fab/blob/master/example/ss/left.gif?raw=true" width="320px"/>


## Getting started

```dart
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

Scaffold(
  floatingActionButtonLocation: ExpandableFab.location,
  floatingActionButton: ExpandableFab(
    children: [
      FloatingActionButton.small(
        child: const Icon(Icons.edit),
        onPressed: () {},
      ),
      FloatingActionButton.small(
        child: const Icon(Icons.search),
        onPressed: () {},
      ),
    ],
  ),
),

```


## Open/Close programmatically

```dart
final _key = GlobalKey<ExpandableFabState>();

Scaffold(
  floatingActionButtonLocation: ExpandableFab.location,
  floatingActionButton: ExpandableFab(
    key: _key,
    children: [
      FloatingActionButton.small(
        child: const Icon(Icons.edit),
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

```


## Properties

| Property |Description| Default |
| --- | ---- | --- |
| distance | Distance from children | 100 |
| duration | Animation duration | 250ms |
| fanAngle | Angle of opening when fan type | 90 |
| initialOpen | Open at initial display | false |
| type | The type of behavior of this widget | fan |
| closeButtonStyle | Style of the close button |  |
| child | The widget below this widget in the tree |  |
| childrenOffset | For positioning of children widgets |  |
| children | The widgets below this widget in the tree |  |
| foregroundColor | The default foreground color for icons and text within the button |  |
| backgroundColor | The button's background color |  |
| beforeOpen | Will be called before opening the menu |  |
| afterOpen | Will be called after opening the menu |  |
| beforeClose | Will be called before the menu closes |  |
| afterClose | Will be called after the menu closes |  |
| overlayStyle | Provides the style for overlay. No overlay when null. |  |



