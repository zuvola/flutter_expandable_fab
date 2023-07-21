import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../flutter_expandable_fab.dart';

class FloatingActionButtonBuilder {
  const FloatingActionButtonBuilder({
    this.size = ExpandableFabSize.regular,
    required this.builder,
  });

  final Widget Function(BuildContext context, VoidCallback? onPressed,
      Animation<double> progress) builder;

  /// The size of the FAB.
  final ExpandableFabSize size;
}

class DefaultFloatingActionButtonBuilder extends FloatingActionButtonBuilder {
  DefaultFloatingActionButtonBuilder({
    super.size,
    this.foregroundColor,
    this.backgroundColor,
    this.shape,
    this.heroTag,
    this.child,
  }) : super(builder: (BuildContext context, VoidCallback? onPressed,
            Animation<double> progress) {
          var func = FloatingActionButton.small;
          switch (size) {
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
        });

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
    super.size,
    this.foregroundColor,
    this.backgroundColor,
    this.shape,
    this.heroTag,
    this.child,
    this.angle = math.pi / 2,
  }) : super(builder: (BuildContext context, VoidCallback? onPressed,
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
                  size: size,
                  child: child,
                ).builder(context, onPressed, progress),
              );
            },
          );
        });

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
