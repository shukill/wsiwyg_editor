import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:wysiwyg_editor/state/state.dart';

class KElementsBottomSheet extends StatelessWidget {
  final String title;
  final TextStyle? titleTextStyle, itemTextStyle;
  final double? iconSize;
  final Color? iconColor;
  final EditorController controller;
  final Function()? onInsertHyperlink;
  final Function()? onInsertMedia;
  final Function()? onInsertVideoEmbed;

  const KElementsBottomSheet(
      {super.key,
      required this.controller,
      this.title = "Insert",
      this.titleTextStyle,
      this.itemTextStyle,
      this.iconSize,
      this.iconColor,
      this.onInsertHyperlink,
      this.onInsertMedia,
      this.onInsertVideoEmbed});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    const double defaultIconSize = 20;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                title,
                style: titleTextStyle ?? textTheme.titleLarge,
              ),
              if (kIsWeb) ...[
                const Spacer(),
                CloseButton(onPressed: Navigator.of(context).pop),
              ]
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            dense: true,
            onTap: () {
              Navigator.of(context).pop();
              onInsertHyperlink?.call();
            },
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.link,
                size: iconSize ?? defaultIconSize, color: iconColor ?? Colors.black),
            title: Text(
              "Link",
              style: itemTextStyle ?? textTheme.bodyMedium,
            ),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            dense: true,
            onTap: () {
              Navigator.of(context).pop();
              onInsertMedia?.call();
            },
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.image,
                size: iconSize ?? defaultIconSize, color: iconColor ?? Colors.black),
            title: Text(
              "Media",
              style: itemTextStyle ?? textTheme.bodyMedium,
            ),
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            dense: true,
            onTap: () {
              Navigator.of(context).pop();
              onInsertVideoEmbed?.call();
            },
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.video_library,
                size: iconSize ?? defaultIconSize, color: iconColor ?? Colors.black),
            title: Text(
              "Youtube Embed",
              style: itemTextStyle ?? textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
