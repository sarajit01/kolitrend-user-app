import 'package:flutter/material.dart';

class TappableTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final TextStyle? textStyle;
  final Offset? offset; // To adjust the tooltip's position relative to the child

  const TappableTooltip({
    Key? key,
    required this.child,
    required this.message,
    this.padding,
    this.decoration,
    this.textStyle,
    this.offset,
  }) : super(key: key);

  @override
  _TappableTooltipState createState() => _TappableTooltipState();
}

class _TappableTooltipState extends State<TappableTooltip> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _showTooltip() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var childSize = renderBox.size;
    var childOffset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) =>
          Positioned(
            left: childOffset.dx + (widget.offset?.dx ?? 0),
            top: childOffset.dy + childSize.height + (widget.offset?.dy ?? 5.0),
            // Position below the child
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: widget.offset ?? Offset(0.0, childSize.height + 5.0),
              // Adjust as needed
              child: Material( // Material for theming and elevation
                elevation: 1.0,
                child: Container(
                  padding: widget.padding ?? const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 6.0),
                  decoration: widget.decoration ?? BoxDecoration(
                    color: Colors.grey[700]?.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    widget.message,
                    style: widget.textStyle ??
                        const TextStyle(color: Colors.white, fontSize: 12.0),
                  ),
                ),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget( // Helps link the overlay to this widget
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (_overlayEntry == null) {
            _showTooltip();
            // Optional: Auto-hide after a delay
            Future.delayed(const Duration(seconds: 3), () {
              if (mounted && _overlayEntry != null) {
                _hideTooltip();
              }
            });
          } else {
            _hideTooltip(); // Tap again to hide
          }
        },
        // Optional: Hide if user taps outside
        // behavior: HitTestBehavior.opaque, // If you want to use this with a global tap detector
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _hideTooltip(); // Ensure overlay is removed when widget is disposed
    super.dispose();
  }
}

