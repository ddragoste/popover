import 'package:flutter/material.dart';

import '../popover.dart';
import 'popover_context.dart';
import 'popover_position_widget.dart';

class PopoverItem extends StatefulWidget {
  final Widget child;
  final Color? backgroundColor;
  final PopoverDirection? direction;
  final double? radius;
  final List<BoxShadow>? boxShadow;
  final Animation<double> animation;
  final double? arrowWidth;
  final double arrowHeight;
  final BoxConstraints? constraints;
  final BuildContext context;
  final PopoverTransition transition;
  final Rect attachRect;

  const PopoverItem({
    required this.child,
    required this.context,
    required this.transition,
    required this.animation,
    required this.arrowHeight,
    required this.attachRect,
    this.backgroundColor,
    this.direction,
    this.radius,
    this.boxShadow,
    this.arrowWidth,
    this.constraints,
    super.key,
  });

  @override
  _PopoverItemState createState() => _PopoverItemState();
}

class _PopoverItemState extends State<PopoverItem> {
  late BoxConstraints _constraints;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PopoverPositionWidget(
          attachRect: widget.attachRect,
          constraints: _constraints,
          direction: widget.direction,
          arrowHeight: widget.arrowHeight,
          child: AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) {
              return PopoverContext(
                attachRect: widget.attachRect,
                animation: widget.animation,
                radius: widget.radius,
                backgroundColor: widget.backgroundColor,
                boxShadow: widget.boxShadow,
                direction: widget.direction,
                arrowWidth: widget.arrowWidth,
                arrowHeight: widget.arrowHeight,
                transition: widget.transition,
                child: child,
              );
            },
            child: Material(
              child: widget.child,
              color: widget.backgroundColor,
            ),
          ),
        )
      ],
    );
  }

  @override
  void didChangeDependencies() {
    _configureConstraints();

    super.didChangeDependencies();
  }

  void _configureConstraints() {
    final size = MediaQuery.of(context).size;
    var constraints = BoxConstraints.loose(size);

    if (widget.constraints != null) {
      constraints = constraints.copyWith(
        minWidth: widget.constraints!.minWidth.isFinite
            ? widget.constraints!.minWidth
            : null,
        minHeight: widget.constraints!.minHeight.isFinite
            ? widget.constraints!.minHeight
            : null,
        maxWidth: widget.constraints!.maxWidth.isFinite
            ? widget.constraints!.maxWidth
            : null,
        maxHeight: widget.constraints!.maxHeight.isFinite
            ? widget.constraints!.maxHeight
            : null,
      );
    }

    if (widget.direction == PopoverDirection.top ||
        widget.direction == PopoverDirection.bottom) {
      final maxHeight = constraints.maxHeight + widget.arrowHeight;
      constraints = constraints.copyWith(maxHeight: maxHeight);
    } else {
      constraints = constraints.copyWith(
        maxHeight: constraints.maxHeight + widget.arrowHeight,
        maxWidth: constraints.maxWidth + widget.arrowWidth!,
      );
    }

    _constraints = constraints;
  }
}
