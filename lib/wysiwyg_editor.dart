import 'package:flutter/material.dart';
import 'package:wysiwyg_flutter_quill/flutter_quill.dart';
import 'package:provider/provider.dart';
import 'package:wysiwyg_editor/components/components.dart';
import 'package:wysiwyg_editor/core/core.dart';
import 'package:wysiwyg_editor/state/editor_controller.dart';

class WYSIWYGEditor extends StatelessWidget {
  static const List<dynamic> emptyContent = [
    {"insert": " \n"}
  ];

  final EditorController controller;
  final FocusNode focusNode;
  final EdgeInsets? padding;
  final bool autoFocus;
  final Function(String url) onLaunchUrl;
  final DefaultStyles customStyles;
  final bool readOnly, cursorEnabled;
  final Widget Function(KCustomAttachmentData embedData, Embed node, bool readOnly, bool inline, TextStyle textStyle)? attachmentEmbedBuilder;
  final Widget Function(KCustomVideoEmbedData embedData, Embed node, bool readOnly, bool inline, TextStyle textStyle)? videoEmbedBuilder;
  final List<dynamic> customEmbedBuilders;
  final String? hint;

  const WYSIWYGEditor({
    super.key,
    this.padding,
    required this.focusNode,
    required this.onLaunchUrl,
    required this.customStyles,
    required this.controller,
    this.autoFocus = true,
    this.attachmentEmbedBuilder,
    this.videoEmbedBuilder,
    this.readOnly = false,
    this.cursorEnabled = true,
    this.customEmbedBuilders = const [],
    this.hint = "Write your post here",
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditorController>.value(
        value: controller,
        builder: (context, _) {
          final EditorController controller = context.watch<EditorController>();
          // controller.quillController.readOnly =
          //     readOnly || !controller.allowCursor;
          return QuillEditor(
            configurations: QuillEditorConfigurations(
              autoFocus: autoFocus,
              controller: controller.quillController,
              checkBoxReadOnly: readOnly || !controller.allowCursor,
              placeholder: hint,
              expands: true,
              showCursor: cursorEnabled && controller.allowCursor,
              padding: padding ?? EdgeInsets.zero,
              onLaunchUrl: onLaunchUrl,
              customStyles: customStyles,
              embedBuilders: [DefaultKAttachmentEmbedBuilder(embedBuilder: attachmentEmbedBuilder), DefaultKVideoEmbedBuilder(embedBuilder: videoEmbedBuilder), ...customEmbedBuilders],
              scrollable: true,
            ),
            scrollController: controller.scrollController,
            focusNode: focusNode,

            // embedBuilder: quillEditingEmbedBuilder,
          );
        });
  }
}
