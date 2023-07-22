import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The size of the expanded FAB.
enum ExpandableFabSize { small, regular, large }

class FloatingActionButtonBuilder {
  const FloatingActionButtonBuilder({
    required this.size,
    required this.builder,
  });

  final Widget Function(BuildContext context, VoidCallback? onPressed,
      Animation<double> progress) builder;

  /// The size of the FAB.
  final double size;
}

double _actualSize(ExpandableFabSize fabSize) {
  switch (fabSize) {
    case ExpandableFabSize.large:
      return 96.0;
    case ExpandableFabSize.small:
      return 40.0;
    default:
      return 56.0;
  }
}

class DefaultFloatingActionButtonBuilder extends FloatingActionButtonBuilder {
  DefaultFloatingActionButtonBuilder({
    this.fabSize = ExpandableFabSize.regular,
    this.foregroundColor,
    this.backgroundColor,
    this.shape,
    this.heroTag,
    this.child,
  }) : super(
          size: _actualSize(fabSize),
          builder: (BuildContext context, VoidCallback? onPressed,
              Animation<double> progress) {
            var func = FloatingActionButton.small;
            switch (fabSize) {
              case ExpandableFabSize.large:
                func = FloatingActionButton.large;
                break;
              case ExpandableFabSize.small:
                break;
              default:
                func = FloatingActionButton.new;
            }
            return func.call(
              foregroundColor: foregroundColor,
              backgroundColor: backgroundColor,
              shape: shape,
              heroTag: heroTag,
              onPressed: onPressed,
              child: child,
            );
          },
        );

  /// The size of the FAB.
  final ExpandableFabSize fabSize;

  /// The default foreground color for icons and text within the button.
  final Color? foregroundColor;

  /// The button's background color.
  final Color? backgroundColor;

  /// The shape of the FAB's [Material].
  final ShapeBorder? shape;

  /// The tag to apply to the button's [Hero] widget.
  final Object? heroTag;

  /// The widget below the button widget in the tree.
  final Widget? child;
}

class RotateFloatingActionButtonBuilder extends FloatingActionButtonBuilder {
  RotateFloatingActionButtonBuilder({
    this.fabSize = ExpandableFabSize.regular,
    this.foregroundColor,
    this.backgroundColor,
    this.shape,
    this.heroTag,
    this.child,
    this.angle = math.pi / 2,
  }) : super(
          size: _actualSize(fabSize),
          builder: (BuildContext context, VoidCallback? onPressed,
              Animation<double> progress) {
            return AnimatedBuilder(
              animation: progress,
              builder: (context, _) {
                return Transform.rotate(
                  angle: progress.value * angle,
                  child: DefaultFloatingActionButtonBuilder(
                    foregroundColor: foregroundColor,
                    backgroundColor: backgroundColor,
                    shape: shape,
                    heroTag: heroTag,
                    fabSize: fabSize,
                    child: child,
                  ).builder(context, onPressed, progress),
                );
              },
            );
          },
        );

  /// The size of the FAB.
  final ExpandableFabSize fabSize;

  /// The default foreground color for icons and text within the button.
  final Color? foregroundColor;

  /// The button's background color.
  final Color? backgroundColor;

  /// The shape of the FAB's [Material].
  final ShapeBorder? shape;

  /// The tag to apply to the button's [Hero] widget.
  final Object? heroTag;

  /// The widget below the button widget in the tree.
  final Widget? child;

  final double angle;
}
