library flutter_expandable_fab;

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

// Inspired by this article.
// https://docs.flutter.dev/cookbook/effects/expandable-fab

/// The type of behavior of this widget.
enum ExpandableFabType { fan, up, left }

/// The size of the expanded FAB.
enum ExpandableFabSize { small, regular }

/// position of the FAB
enum ExpandableFabPosition { left, right }

/// The type of transformation
enum ExpandableFabAnimation { rotate, expanded }

/// Style of the overlay.
@immutable
class ExpandableFabOverlayStyle {
  ExpandableFabOverlayStyle({
    this.color,
    this.blur,
  }) {
    assert(color == null || blur == null);
    assert(color != null || blur != null);
  }

  /// The color to paint behind the Fab.
  final Color? color;

  /// The strength of the blur behind Fab.
  final double? blur;
}

/// Style of the close button.
@immutable
class ExpandableFabCloseButtonStyle {
  const ExpandableFabCloseButtonStyle({
    this.child = const Icon(Icons.close),
    this.foregroundColor,
    this.backgroundColor,
  });

  /// The widget below the close button widget in the tree.
  final Widget child;

  /// The default foreground color for icons and text within the button.
  final Color? foregroundColor;

  /// The button's background color.
  final Color? backgroundColor;
}

class _ExpandableFabLocation extends StandardFabLocation {
  final ValueNotifier<ScaffoldPrelayoutGeometry?> scaffoldGeometry =
      ValueNotifier(null);

  @override
  double getOffsetX(
      ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    Future.microtask(() {
      this.scaffoldGeometry.value = scaffoldGeometry;
    });
    return 0;
  }

  @override
  double getOffsetY(
      ScaffoldPrelayoutGeometry scaffoldGeometry, double adjustment) {
    return -scaffoldGeometry.snackBarSize.height;
  }
}

/// Fab button that can show/hide multiple action buttons with animation.
@immutable
class ExpandableFab extends StatefulWidget {
  static final FloatingActionButtonLocation location = _ExpandableFabLocation();

  const ExpandableFab({
    Key? key,
    this.distance = 100,
    this.duration = const Duration(milliseconds: 250),
    this.fanAngle = 90,
    this.initialOpen = false,
    this.type = ExpandableFabType.fan,
    this.collapsedFabSize = ExpandableFabSize.regular,
    this.expandedFabSize = ExpandableFabSize.small,
    this.collapsedFabShape,
    this.expandedFabShape,
    this.closeButtonStyle = const ExpandableFabCloseButtonStyle(),
    this.foregroundColor,
    this.backgroundColor,
    this.child = const Icon(Icons.menu),
    this.childrenOffset = const Offset(4, 4),
    required this.children,
    this.onOpen,
    this.afterOpen,
    this.onClose,
    this.afterClose,
    this.overlayStyle,
    this.openButtonHeroTag,
    this.closeButtonHeroTag,
    this.expandableFabPosition = ExpandableFabPosition.right,
    this.expandableFabAnimation = ExpandableFabAnimation.rotate,
  }) : super(key: key);

  /// Distance from children.
  final double distance;

  /// Animation duration.
  final Duration duration;

  /// Angle of opening when fan type.
  final double fanAngle;

  /// Open at initial display.
  final bool initialOpen;

  /// The type of behavior of this widget.
  final ExpandableFabType type;

  /// The size of the collapsed FAB.
  final ExpandableFabSize collapsedFabSize;

  /// The size of the expanded FAB.
  final ExpandableFabSize expandedFabSize;

  /// The shape of the expanded FAB's [Material].
  final ShapeBorder? expandedFabShape;

  /// The shape of the collapsed FAB's [Material].
  final ShapeBorder? collapsedFabShape;

  /// Style of the close button.
  final ExpandableFabCloseButtonStyle closeButtonStyle;

  /// The widget below this widget in the tree.
  final Widget child;

  /// For positioning of children widgets.
  final Offset childrenOffset;

  /// The widgets below this widget in the tree.
  final List<Widget> children;

  /// The default foreground color for icons and text within the button.
  final Color? foregroundColor;

  /// The button's background color.
  final Color? backgroundColor;

  /// Will be called before opening the menu.
  final VoidCallback? onOpen;

  /// Will be called after opening the menu.
  final VoidCallback? afterOpen;

  /// Will be called before the menu closes.
  final VoidCallback? onClose;

  /// Will be called after the menu closes.
  final VoidCallback? afterClose;

  /// Provides the style for overlay. No overlay when null.
  final ExpandableFabOverlayStyle? overlayStyle;

  /// The tag to apply to the open button's [Hero] widget.
  final Object? openButtonHeroTag;

  /// The tag to apply to the close button's [Hero] widget.
  final Object? closeButtonHeroTag;

  /// The alignment of FAB
  final ExpandableFabPosition? expandableFabPosition;

  /// The type of transformation animation
  final ExpandableFabAnimation expandableFabAnimation;

  @override
  State<ExpandableFab> createState() => ExpandableFabState();
}

class ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  /// Returns whether the menu is open
  bool get isOpen => _open;

  /// Display or hide the menu.
  void toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        widget.onOpen?.call();
        _controller.forward().then((value) {
          widget.afterOpen?.call();
        });
      } else {
        widget.onClose?.call();
        _controller.reverse().then((value) {
          widget.afterClose?.call();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: widget.duration,
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final location = ExpandableFab.location as _ExpandableFabLocation;
    Offset? offset;
    Widget? cache;
    return ValueListenableBuilder<ScaffoldPrelayoutGeometry?>(
      valueListenable: location.scaffoldGeometry,
      builder: ((context, geometry, child) {
        if (geometry == null) {
          return const SizedBox.shrink();
        }
        final x = kFloatingActionButtonMargin +
            (widget.expandableFabPosition == ExpandableFabPosition.right
                ? geometry.minInsets.right
                : geometry.minInsets.left);
        final bottomContentHeight =
            geometry.scaffoldSize.height - geometry.contentBottom;
        final y = kFloatingActionButtonMargin +
            math.max(geometry.minViewPadding.bottom, bottomContentHeight);
        if (offset != Offset(x, y)) {
          offset = Offset(x, y);
          cache = _buildButtons(offset!);
        }
        return cache!;
      }),
    );
  }

  Widget _buildButtons(Offset offset) {
    final blur = widget.overlayStyle?.blur;
    final overlayColor = widget.overlayStyle?.color;
    return GestureDetector(
      onTap: () => toggle(),
      child: Stack(
        alignment: widget.expandableFabPosition == ExpandableFabPosition.right
            ? Alignment.bottomRight
            : Alignment.bottomLeft,
        children: [
          Container(),
          if (blur != null)
            IgnorePointer(
              ignoring: !_open,
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: _open ? blur : 0.0),
                duration: widget.duration,
                curve: Curves.easeInOut,
                builder: (_, value, child) {
                  if (value < 0.001) {
                    return child!;
                  }
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: value, sigmaY: value),
                    child: child,
                  );
                },
                child: Container(color: Colors.transparent),
              ),
            ),
          if (overlayColor != null)
            IgnorePointer(
              ignoring: !_open,
              child: AnimatedOpacity(
                duration: widget.duration,
                opacity: _open ? 1 : 0,
                curve: Curves.easeInOut,
                child: Container(
                  color: overlayColor,
                ),
              ),
            ),
          ..._buildExpandingActionButtons(offset),
          Transform.translate(
            offset: widget.expandableFabPosition == ExpandableFabPosition.right
                ? -offset
                : -offset + Offset(offset.dx * 2, 0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                _buildTapToCloseFab(),
                _buildTapToOpenFab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    final style = widget.closeButtonStyle;
    switch (widget.expandedFabSize) {
      case ExpandableFabSize.small:
        return FloatingActionButton.small(
          heroTag: widget.closeButtonHeroTag,
          foregroundColor: style.foregroundColor,
          backgroundColor: style.backgroundColor,
          shape: widget.expandedFabShape,
          onPressed: toggle,
          child: style.child,
        );
      case ExpandableFabSize.regular:
        return FloatingActionButton(
          heroTag: widget.closeButtonHeroTag,
          foregroundColor: style.foregroundColor,
          backgroundColor: style.backgroundColor,
          shape: widget.expandedFabShape,
          onPressed: toggle,
          child: style.child,
        );
    }
  }

  List<Widget> _buildExpandingActionButtons(Offset offset) {
    final children = <Widget>[];
    final count = widget.children.length;
    final addedDistance =
        widget.expandedFabSize == ExpandableFabSize.regular ? 8 : 0;
    for (var i = 0; i < count; i++) {
      final double dir, dist;
      switch (widget.type) {
        case ExpandableFabType.fan:
          if (count > 1) {
            dir = widget.fanAngle / (count - 1) * i;
          } else {
            dir = widget.fanAngle;
          }
          dist = widget.distance + addedDistance;
          break;
        case ExpandableFabType.up:
          dir = 90;
          dist = widget.distance * (i + 1) + addedDistance;
          break;
        case ExpandableFabType.left:
          dir = 0;
          dist = widget.distance * (i + 1) + addedDistance;
          break;
      }
      children.add(
        _ExpandingActionButton(
          directionInDegrees: dir + (90 - widget.fanAngle) / 2,
          maxDistance: dist,
          progress: _expandAnimation,
          offset: offset + widget.childrenOffset,
          expandableFabPosition:
              widget.expandableFabPosition ?? ExpandableFabPosition.right,
          expandableFabAnimation: widget.expandableFabAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    final duration = widget.duration;
    final transformValues =
        widget.expandedFabSize == ExpandableFabSize.regular ? 1.0 : 0.715;

    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? transformValues : 1.0,
          _open ? transformValues : 1.0,
          1.0,
        ),
        duration: duration,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: duration,
          child: widget.collapsedFabSize == ExpandableFabSize.regular
              ? FloatingActionButton(
                  heroTag: widget.openButtonHeroTag,
                  foregroundColor: widget.foregroundColor,
                  backgroundColor: widget.backgroundColor,
                  shape: widget.collapsedFabShape,
                  onPressed: toggle,
                  child: AnimatedRotation(
                    duration: duration,
                    turns: _open ? -0.5 : 0,
                    child: widget.child,
                  ),
                )
              : FloatingActionButton.small(
                  heroTag: widget.openButtonHeroTag,
                  foregroundColor: widget.foregroundColor,
                  backgroundColor: widget.backgroundColor,
                  shape: widget.collapsedFabShape,
                  onPressed: toggle,
                  child: AnimatedRotation(
                    duration: duration,
                    turns: _open ? -0.5 : 0,
                    child: widget.child,
                  ),
                ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
    required this.offset,
    required this.expandableFabPosition,
    required this.expandableFabAnimation,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Offset offset;
  final Widget child;
  final ExpandableFabPosition expandableFabPosition;
  final ExpandableFabAnimation expandableFabAnimation;

  @override
  Widget build(BuildContext context) {
    final rotateAngleDirection =
        expandableFabPosition == ExpandableFabPosition.right ? 1 : -1;

    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final pos = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          left: expandableFabPosition == ExpandableFabPosition.left
              ? offset.dx + pos.dx
              : null,
          right: expandableFabPosition == ExpandableFabPosition.right
              ? offset.dx + pos.dx
              : null,
          bottom: offset.dy + pos.dy,
          child: expandableFabAnimation == ExpandableFabAnimation.rotate
              ? Transform.rotate(
                  angle: ((1.0 - progress.value) * math.pi / 2) *
                      rotateAngleDirection,
                  child: IgnorePointer(
                    ignoring: progress.value != 1,
                    child: child,
                  ),
                )
              : Transform.translate(
                  offset: const Offset(0, 1),
                  // ((1.0 - progress.value) * math.pi / 2) * rotateAngleDirection,
                  child: IgnorePointer(
                    ignoring: progress.value != 1,
                    child: child,
                  ),
                ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
