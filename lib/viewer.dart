import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:wysiwyg_editor/components/components.dart';
import 'package:wysiwyg_editor/core/core.dart';

class WYSIWYGEditorPreview extends StatefulWidget {
  final EdgeInsets padding;
  final Function(String url) onLaunchUrl;
  final List<dynamic> delta;
  final TextStyle? textStyle;
  final bool expands;
  final Widget Function(KCustomAttachmentData embedData, Embed node, bool readOnly, bool inline,
      TextStyle textStyle)? attachmentEmbedBuilder;
  final Widget Function(KCustomVideoEmbedData embedData, Embed node, bool readOnly, bool inline,
      TextStyle textStyle)? videoEmbedBuilder;
  final List<dynamic> customEmbedBuilders;
  final DefaultStyles? customStyle;

  const WYSIWYGEditorPreview({
    super.key,
    this.padding = EdgeInsets.zero,
    required this.onLaunchUrl,
    this.attachmentEmbedBuilder,
    this.videoEmbedBuilder,
    this.customEmbedBuilders = const [],
    required this.delta,
    this.textStyle,
    required this.expands,
    this.customStyle,
  });

  @override
  State<WYSIWYGEditorPreview> createState() => _WYSIWYGEditorPreviewState();
}

class _WYSIWYGEditorPreviewState extends State<WYSIWYGEditorPreview> {
  QuillController? _quillController;
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  @override
  void didUpdateWidget(covariant WYSIWYGEditorPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(widget.delta, oldWidget.delta)) {
      updateDelta();
    }
  }

  void updateDelta() {
    final document = Document.fromJson(
      widget.delta,
    );

    _quillController?.clear();

    if (_quillController != null) {
      _quillController?.compose(
        document.toDelta(),
        const TextSelection(baseOffset: 0, extentOffset: 0),
        ChangeSource.local,
      );
    } else {
      _quillController = QuillController(
          document: document,
          selection: const TextSelection(baseOffset: 0, extentOffset: 0),
          readOnly: true);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    updateDelta();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _quillController?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _quillController.readOnly = true;
    if (_quillController == null) return const SizedBox.shrink();

    return QuillEditor(
      scrollController: _scrollController,
      focusNode: _focusNode,
      controller: _quillController!,
      configurations: QuillEditorConfigurations(
        autoFocus: true,
        scrollable: true,
        padding: widget.padding,
        showCursor: false,
        onLaunchUrl: widget.onLaunchUrl,
        expands: widget.expands,
        customStyles: widget.customStyle,
        embedBuilders: [
          DefaultKAttachmentEmbedBuilder(embedBuilder: widget.attachmentEmbedBuilder),
          DefaultKVideoEmbedBuilder(embedBuilder: widget.videoEmbedBuilder),
          ...widget.customEmbedBuilders
        ],
      ),
      // embedBuilder: quillEmbedBuilder,
    );
  }
}
