import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wysiwyg_flutter_quill/flutter_quill.dart' as quill;
import 'package:wysiwyg_editor/components/components.dart';
import 'package:wysiwyg_editor/core/core.dart';

class DefaultKVideoEmbedBuilder extends quill.EmbedBuilder {
  final Widget Function(KCustomVideoEmbedData embedData, quill.Embed node, bool readOnly, bool inline, TextStyle textStyle)? embedBuilder;

  DefaultKVideoEmbedBuilder({this.embedBuilder});

  @override
  String get key => KVideoEmbedBlockEmbed.customType;

  @override
  Widget build(BuildContext context, quill.QuillController controller, quill.Embed node, bool readOnly, bool inline, TextStyle textStyle) {
    try {
      if (node.value.type == key) {
        final KCustomVideoEmbedData data = KCustomVideoEmbedData.fromMap(jsonDecode(node.value.data as String));
        return embedBuilder?.call(data, node, readOnly, inline, textStyle) ??
            SizeModeWrapper(
              sizeMode: data.sizeMode,
              builder: (BuildContext context, Size size) {
                return AspectRatio(
                  aspectRatio: data.aspectRatio,
                  child: Container(color: Colors.grey.shade300, child: const Center(child: Text("Video Embed Implementation"))),
                );
              },
            );
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return Container();
  }
}
