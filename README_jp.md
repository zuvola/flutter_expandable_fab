# flutter_expandable_fab

[![pub package](https://img.shields.io/pub/v/flutter_expandable_fab.svg)](https://pub.dartlang.org/packages/flutter_expandable_fab)


**[English](https://github.com/zuvola/flutter_expandable_fab/blob/master/README.md), [日本語](https://github.com/zuvola/flutter_expandable_fab/blob/master/README_jp.md)**


`flutter_expandable_fab`は複数のアクションボタンをアニメーションで表示・非表示できるFabボタンです。  
こちらの記事のコードを拡張したものになります。  
https://docs.flutter.dev/cookbook/effects/expandable-fab


### Fan style

<img src="https://github.com/zuvola/flutter_expandable_fab/blob/master/res/fan.gif?raw=true" width="320px"/>

### Vertical style

<img src="https://github.com/zuvola/flutter_expandable_fab/blob/master/res/up.gif?raw=true" width="320px"/>


## Getting started

```dart
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

Scaffold(
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


