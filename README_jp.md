# flutter_expandable_fab

[![pub package](https://img.shields.io/pub/v/flutter_expandable_fab.svg)](https://pub.dartlang.org/packages/flutter_expandable_fab)


**[English](https://github.com/zuvola/flutter_expandable_fab/blob/master/README.md), [日本語](https://github.com/zuvola/flutter_expandable_fab/blob/master/README_jp.md)**


`flutter_expandable_fab`は複数のアクションボタンをアニメーションで表示・非表示できるスピードダイアルFABです。  
こちらの記事のコードを拡張したものになります。  
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
| distance | 子アイテムとの距離 | 100 |
| duration | アニメーション時間 | 250ms |
| fanAngle | 扇タイプでの角度 | 90 |
| initialOpen | 初期表示時に開く | false |
| type | このウィジェットの動作タイプ | fan |
| closeButtonStyle | 閉じるボタンのスタイル |  |
| child | 子ウィジェット |  |
| childrenOffset | 子アイテムの位置調整 |  |
| children | 子アイテム |  |
| foregroundColor | 子ウィジェットのフォアグラウンドカラー |  |
| backgroundColor | ボタンの背景色 |  |
| onOpen | メニューを開く前に呼び出されます |  |
| afterOpen | メニューを開いた後に呼び出されます |  |
| onClose | メニューが閉じる前に呼び出されます |  |
| afterClose | メニューが閉じた後に呼び出されます |  |
| overlayStyle | オーバーレイのスタイル、nullで非表示 |  |
| openButtonHeroTag | 開くボタンの[Hero]ウィジェットに適用するタグ |  |
| closeButtonHeroTag | 閉じるボタンの[Hero]ウィジェットに適用するタグ |  |


