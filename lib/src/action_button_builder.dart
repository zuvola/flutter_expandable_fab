import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The size of the expanded FAB.
enum ExpandableFabSize { small, regular, large }

/// A builder class for creating a customized Floating Action Button (FAB).
///
/// ```dart
/// FloatingActionButtonBuilder(
///   size: 56,
///   builder: (BuildContext context, void Function()? onPressed, Animation<double> progress) {
///     return IconButton(
///       onPressed: onPressed,
///       icon: const Icon(
///         Icons.menu_open,
///         size: 40,
///       ),
///     );
///   },
/// )
/// ```
///
class FloatingActionButtonBuilder {
  /// Creates a `FloatingActionButtonBuilder` with the specified parameters.
  ///
  /// - [size]: The size of the FAB. It must be a non-null value.
  /// - [builder]: A callback function that defines the appearance and behavior of the FAB.
  const FloatingActionButtonBuilder({
    required this.size,
    required this.builder,
  });

  /// The callback function used to build the FAB.
  ///
  /// This function takes three parameters:
  /// - [context]: The build context.
  /// - [onPressed]: A callback that will be executed when the FAB is pressed.
  /// - [progress]: Animation representing the expansion and contraction of the FAB.
  final Widget Function(BuildContext context, VoidCallback? onPressed,
      Animation<double> progress) builder;

  /// The size of the FAB. Used for position calculations and animations.
  final double size;
}

/// A default implementation of `FloatingActionButtonBuilder` to create a standard FAB.
class DefaultFloatingActionButtonBuilder extends FloatingActionButtonBuilder {
  /// Creates a `DefaultFloatingActionButtonBuilder` with the specified optional parameters.
  ///
  /// - [fabSize]: The size of the FAB, represented by an `ExpandableFabSize` enum value.
  /// - [foregroundColor]: The default foreground color for icons and text within the button.
  /// - [backgroundColor]: The button's background color.
  /// - [shape]: The shape of the FAB's [Material].
  /// - [heroTag]: The tag to apply to the button's [Hero] widget.
  /// - [child]: The widget below the button widget in the tree.
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
              autofocus: true,
              foregroundColor: foregroundColor,
              backgroundColor: backgroundColor,
              shape: shape,
              heroTag: heroTag,
              onPressed: onPressed,
              child: child,
            );
          },
        );

  /// The size of the FAB, represented by an `ExpandableFabSize` enum value.
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

/// A builder class for creating a customized Floating Action Button (FAB) with rotation animation.
class RotateFloatingActionButtonBuilder extends FloatingActionButtonBuilder {
  /// Creates a `RotateFloatingActionButtonBuilder` with the specified optional parameters.
  ///
  /// - [fabSize]: The size of the FAB, represented by an `ExpandableFabSize` enum value.
  /// - [foregroundColor]: The default foreground color for icons and text within the button.
  /// - [backgroundColor]: The button's background color.
  /// - [shape]: The shape of the FAB's [Material].
  /// - [heroTag]: The tag to apply to the button's [Hero] widget.
  /// - [child]: The widget below the button widget in the tree.
  /// - [angle]: The angle of rotation to apply to the FAB, in radians.
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

  ///　The angle of rotation to be applied to the animation, in radians.
  final double angle;
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
