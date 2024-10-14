import 'package:flutter/material.dart';
import 'package:wysiwyg_editor/components/components.dart';
import 'package:wysiwyg_editor/state/state.dart';
import 'package:wysiwyg_flutter_quill/flutter_quill.dart' as quill;
import 'package:wysiwyg_editor/utils/editor_functions.dart';

class KTextOptionsBottomSheet extends StatefulWidget {
  final String title;
  final TextStyle? titleTextStyle, itemTextStyle;
  final TextTheme? textTheme;
  final double? iconSize;
  final Color? iconColor;
  final EditorController controller;

  const KTextOptionsBottomSheet({
    super.key,
    required this.controller,
    this.textTheme,
    this.title = "Insert",
    this.titleTextStyle,
    this.itemTextStyle,
    this.iconSize,
    this.iconColor,
  });

  @override
  State<KTextOptionsBottomSheet> createState() => _KTextOptionsBottomSheetState();
}

class _KTextOptionsBottomSheetState extends State<KTextOptionsBottomSheet> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = widget.textTheme ?? Theme.of(context).textTheme;
    textTheme.titleMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.bold);
    return Padding(padding: const EdgeInsets.all(20), child: _TextOptions(controller: widget.controller));
  }
}

class _TextOptions extends StatelessWidget {
  final EditorController controller;

  const _TextOptions({required this.controller});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle? titleText = textTheme.titleMedium?.copyWith(color: Colors.black, fontWeight: FontWeight.bold);
    const double iconSize = 20;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            KStyleButton(controller: controller, icon: Icons.format_bold, iconSize: iconSize, attribute: quill.Attribute.bold),
            KStyleButton(controller: controller, icon: Icons.format_italic, iconSize: iconSize, attribute: quill.Attribute.italic),
            KStyleButton(controller: controller, icon: Icons.format_underline, iconSize: iconSize, attribute: quill.Attribute.underline),
            KStyleButton(controller: controller, icon: Icons.format_overline, iconSize: iconSize, attribute: quill.Attribute.strikeThrough),
            KStyleButton(controller: controller, icon: Icons.superscript, iconSize: iconSize, attribute: quill.Attribute.superscript),
            KStyleButton(controller: controller, icon: Icons.subscript, iconSize: iconSize, attribute: quill.Attribute.subscript),
          ],
        ),
        const Divider(
          height: 4,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            "Style",
            style: titleText,
          ),
          trailing: KHeaderStyleButton(
            controller: controller,
            iconSize: iconSize,
          ),
        ),
        const Divider(
          height: 4,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            "Font Size",
            style: titleText,
          ),
          trailing: KFontSizeButton(
            controller: controller,
            onSelected: (value) {
              Navigator.of(context).pop();
            },
          ),
        ),
        const Divider(
          height: 4,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            "Font Color",
            style: titleText,
          ),
          trailing: KFontColorButton(
            forBackground: false,
            controller: controller,
          ),
        ),
        const Divider(
          height: 4,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          title: Text(
            "Highlight Color",
            style: titleText,
          ),
          trailing: KFontColorButton(
            forBackground: true,
            controller: controller,
          ),
        ),
        const Divider(
          height: 4,
        ),
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 0),
          onTap: () {
            EditorFunctions.clearFormattingForSelection(controller);
            Navigator.of(context).pop();
          },
          title: Text(
            "Clear Formatting",
            style: titleText,
          ),
        ),
      ],
    );
  }
}
