import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../flutter_expandable_fab.dart';

/// The type of behavior of this widget.
enum ExpandableFabType { fan, up, side }

/// The position options for the FAB on the screen.
enum ExpandableFabPos { right, left }

/// Style configuration for the overlay displayed behind the Expandable FAB.
@immutable
class ExpandableFabOverlayStyle {
  /// Creates an `ExpandableFabOverlayStyle` with the specified optional parameters.
  ///
  /// - [color]: The color to paint behind the FAB.
  /// - [blur]: The strength of the blur behind the FAB.
  ///
  /// Only one of [color] or [blur] can be specified; both cannot be non-null at the same time.
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

/// A FloatingActionButton that can show/hide multiple action buttons with animation.
///
/// ```dart
/// Scaffold(
///   floatingActionButtonLocation: ExpandableFab.location,
///   floatingActionButton: ExpandableFab(
///     children: [
///       FloatingActionButton.small(
///         heroTag: null,
///         child: const Icon(Icons.edit),
///         onPressed: () {},
///       ),
///       FloatingActionButton.small(
///         heroTag: null,
///         child: const Icon(Icons.search),
///         onPressed: () {},
///       ),
///     ],
///   ),
/// );
/// ```
///
@immutable
class ExpandableFab extends StatefulWidget {
  /// The location of the ExpandableFab on the screen.
  static final FloatingActionButtonLocation location = _ExpandableFabLocation();

  const ExpandableFab({
    Key? key,
    this.distance = 100,
    this.duration = const Duration(milliseconds: 250),
    this.fanAngle = 90,
    this.initialOpen = false,
    this.type = ExpandableFabType.fan,
    this.pos = ExpandableFabPos.right,
    this.closeButtonBuilder,
    this.openButtonBuilder,
    this.childrenOffset = Offset.zero,
    required this.children,
    this.onOpen,
    this.afterOpen,
    this.onClose,
    this.afterClose,
    this.overlayStyle,
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

  /// The position of the ExpandableFab on the screen
  final ExpandableFabPos pos;

  /// A builder for the custom close button.
  final FloatingActionButtonBuilder? closeButtonBuilder;

  /// A builder for the custom open button.
  final FloatingActionButtonBuilder? openButtonBuilder;

  /// For positioning of children widgets.
  final Offset childrenOffset;

  /// The widgets below this widget in the tree.
  final List<Widget> children;

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

  @override
  State<ExpandableFab> createState() => ExpandableFabState();
}

class ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  late final FloatingActionButtonBuilder _openButtonBuilder;
  late final FloatingActionButtonBuilder _closeButtonBuilder;
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
    _openButtonBuilder = widget.openButtonBuilder ??
        RotateFloatingActionButtonBuilder(
          child: const Icon(Icons.menu),
        );
    _closeButtonBuilder = widget.closeButtonBuilder ??
        DefaultFloatingActionButtonBuilder(
          fabSize: ExpandableFabSize.small,
          child: const Icon(Icons.close),
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
        double x;
        if (widget.pos == ExpandableFabPos.right) {
          x = kFloatingActionButtonMargin + geometry.minInsets.right;
        } else {
          x = -kFloatingActionButtonMargin - geometry.minInsets.left;
        }
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
        alignment: widget.pos == ExpandableFabPos.right
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
            offset: -offset,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedOpacity(
                  opacity: _open ? 1.0 : 0.0,
                  curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
                  duration: widget.duration,
                  child: _closeButtonBuilder.builder(
                      context, toggle, _expandAnimation),
                ),
                _buildTapToOpenFab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons(Offset offset) {
    final children = <Widget>[];
    final count = widget.children.length;
    var buttonOffset = 0.0;
    if (_openButtonBuilder.size > _closeButtonBuilder.size) {
      buttonOffset = (_openButtonBuilder.size - _closeButtonBuilder.size) / 2;
    }
    var totalOffset = offset;
    if (widget.pos == ExpandableFabPos.right) {
      totalOffset += widget.childrenOffset + Offset(buttonOffset, buttonOffset);
    } else {
      totalOffset += Offset(-widget.childrenOffset.dx - buttonOffset,
          widget.childrenOffset.dy + buttonOffset);
    }
    for (var i = 0; i < count; i++) {
      final double dir, dist;
      switch (widget.type) {
        case ExpandableFabType.fan:
          final half = (90 - widget.fanAngle) / 2;
          if (count > 1) {
            dir = widget.fanAngle / (count - 1) * i + half;
          } else {
            dir = widget.fanAngle + half;
          }
          dist = widget.distance;
          break;
        case ExpandableFabType.up:
          dir = 90;
          dist = widget.distance * (i + 1);
          break;
        case ExpandableFabType.side:
          dir = 0;
          dist = widget.distance * (i + 1);
          break;
      }
      children.add(
        _ExpandingActionButton(
          directionInDegrees: dir,
          maxDistance: dist,
          progress: _expandAnimation,
          offset: totalOffset,
          fabPos: widget.pos,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    final duration = widget.duration;
    final transformValues = _closeButtonBuilder.size / _openButtonBuilder.size;

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
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
          duration: duration,
          child: _openButtonBuilder.builder(context, toggle, _expandAnimation),
        ),
      ),
    );
  }
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

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
    required this.fabPos,
    required this.offset,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Offset offset;
  final ExpandableFabPos fabPos;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final pos = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: fabPos == ExpandableFabPos.right ? offset.dx + pos.dx : null,
          left: fabPos == ExpandableFabPos.right ? null : -offset.dx + pos.dx,
          bottom: offset.dy + pos.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
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
