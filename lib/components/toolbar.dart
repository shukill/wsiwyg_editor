import 'package:flutter/material.dart';
import 'package:wysiwyg_flutter_quill/flutter_quill.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wysiwyg_editor/core/assets/asset_string.dart';

class WYSIWYGToolbar extends StatefulWidget {
  final QuillController controller;
  final double svgSize;

  final Size containerSize;
  final Color activeColor;
  final Color inActiveColor;
  final Color backgroundColor;
  final double dividerHeight;
  final double dividerWidth;
  final Color dividerColor;

  const WYSIWYGToolbar(
    this.controller, {
    Key? key,
    this.svgSize = 20.0,
    this.containerSize = const Size(44.0, 44.0),
    this.activeColor = const Color(0xffF0F0F0),
    this.inActiveColor = const Color(0xff545454),
    this.backgroundColor = const Color(0xff2F2F2F),
    this.dividerWidth = 1.0,
    this.dividerHeight = 24.0,
    this.dividerColor = const Color(0xff1D1D1D),
  }) : super(key: key);

  @override
  WYSIWYGToolbarState createState() => WYSIWYGToolbarState();
}

class WYSIWYGToolbarState extends State<WYSIWYGToolbar> {
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  Attribute _currentAlignment = Attribute.leftAlignment;
  OverlayEntry? _overlayEntry;
  bool _canUndo = false;
  bool _canRedo = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_formatListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_formatListener);
    _removeOverlay();
    super.dispose();
  }

  void _formatListener() {
    if (!mounted) return;
    final attrs = widget.controller.getSelectionStyle().attributes;
    setState(() {
      _isBold = attrs.containsKey(Attribute.bold.key);
      _isItalic = attrs.containsKey(Attribute.italic.key);
      _isUnderline = attrs.containsKey(Attribute.underline.key);
      _currentAlignment = attrs[Attribute.align.key] ?? Attribute.leftAlignment;
      _canUndo = widget.controller.hasUndo;
      _canRedo = widget.controller.hasRedo;
    });
  }

  void _toggleFormat(Attribute attribute) {
    widget.controller.formatSelection(
      !widget.controller.getSelectionStyle().attributes.containsKey(attribute.key) ? attribute : Attribute.clone(attribute, null),
    );
  }

  void _applyAlignment(Attribute alignment) {
    if (_currentAlignment == alignment) {
      _removeOverlay();
      return;
    }
    !widget.controller.selection.isCollapsed ? null : widget.controller.formatSelection(alignment);
    _removeOverlay();
  }

  void _showAlignmentOverlay(BuildContext context, Offset position) {
    if (_overlayEntry != null) {
      _removeOverlay();
      return;
    }
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: widget.containerSize.height * 2,
        right: 16,
        child: Material(
          elevation: 4.0,
          color: const Color(0xff0F0F0F),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              border: Border.all(
                color: widget.dividerColor,
                width: 1.0,
              ),
            ),
            child: Row(
              children: [Attribute.leftAlignment, Attribute.centerAlignment, Attribute.rightAlignment, Attribute.justifyAlignment].asMap().entries.map((entry) {
                final index = entry.key;
                final alignment = entry.value;
                return Row(
                  children: [
                    _buildToolbarButton(
                      _getAlignmentIcon(alignment),
                      _currentAlignment == alignment,
                      () {
                        _applyAlignment(alignment);
                      },
                    ),
                    if (index < 3) // Add divider for all but the last item
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: _buildDivider(),
                      )
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  String _getAlignmentIcon(Attribute alignment) {
    switch (alignment.value) {
      case 'left':
        return AssetString.alignLeftIcon;
      case 'center':
        return AssetString.alignCenterIcon;
      case 'right':
        return AssetString.alignRightIcon;
      case 'justify':
        return AssetString.alignJustifyIcon;
      default:
        return AssetString.alignLeftIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildToolbarButton(
            AssetString.undoIcon,
            _canUndo,
            () => widget.controller.undo(),
            isDisableBackground: true,
          ),
          _buildDivider(),
          _buildToolbarButton(
            AssetString.redoIcon,
            _canRedo,
            () => widget.controller.redo(),
            isDisableBackground: true,
          ),
          _buildDivider(),
          _buildToolbarButton(
            AssetString.boldIcon,
            _isBold,
            () => _toggleFormat(Attribute.bold),
          ),
          _buildDivider(),
          _buildToolbarButton(
            AssetString.italicIcon,
            _isItalic,
            () => _toggleFormat(Attribute.italic),
          ),
          _buildDivider(),
          _buildToolbarButton(
            AssetString.underlineIcon,
            _isUnderline,
            () => _toggleFormat(Attribute.underline),
          ),
          _buildDivider(),
          _buildToolbarButton(
            _getAlignmentIcon(_currentAlignment),
            true,
            () {
              final RenderBox renderBox = context.findRenderObject() as RenderBox;
              final position = renderBox.localToGlobal(Offset.zero);
              _showAlignmentOverlay(context, position);
            },
            isDisableBackground: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: widget.dividerWidth,
      height: widget.dividerHeight,
      color: widget.dividerColor,
    );
  }

  Widget _buildToolbarButton(String icon, bool isActive, VoidCallback? onPressed, {Color? iconColor, bool isDisableBackground = false}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: widget.containerSize.width,
        height: widget.containerSize.height,
        decoration: BoxDecoration(
          color: isDisableBackground
              ? Colors.transparent
              : isActive
                  ? widget.backgroundColor
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(36.0),
        ),
        child: Center(
          child: SvgPicture.string(
            icon,
            colorFilter: ColorFilter.mode(
              !isDisableBackground ? widget.activeColor : iconColor ?? (isActive ? widget.activeColor : widget.inActiveColor),
              BlendMode.srcIn,
            ),
            width: widget.svgSize,
            height: widget.svgSize,
          ),
        ),
      ),
    );
  }
}
