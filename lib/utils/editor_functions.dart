import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:wysiwyg_editor/core/core.dart';
import 'package:wysiwyg_editor/state/state.dart';

class EditorFunctions {
  static LinkTextData? extractHyperlinkFromSelection(EditorController controller) {
    final String? link =
        controller.quillController.getSelectionStyle().attributes[Attribute.link.key]?.value;
    final index = controller.quillController.selection.start;

    String? text;
    if (link != null) {
      // text should be the link's corresponding text, not selection
      final leaf = controller.quillController.document.querySegmentLeafNode(index).leaf;
      if (leaf != null) {
        text = leaf.toPlainText();
      }
    }

    final len = controller.quillController.selection.end - index;
    text ??= len == 0 ? '' : controller.quillController.document.getPlainText(index, len);
    return LinkTextData(text: text, link: link ?? '');
  }

  static clearFormattingForSelection(EditorController controller) {
    final attrs = <Attribute>{};
    for (final style in controller.quillController.getAllSelectionStyles()) {
      for (final attr in style.attributes.values) {
        attrs.add(attr);
      }
    }
    for (final attr in attrs) {
      controller.quillController.formatSelection(Attribute.clone(attr, null));
    }
  }

  static addTextElementToEditor(EditorController controller, String text) {
    if (text.isNotEmpty) {
      final index = controller.quillController.selection.baseOffset;
      final length = controller.quillController.selection.extentOffset - index;

      controller.quillController.replaceText(index, length, text, null);

      controller.quillController.moveCursorToPosition(index + text.length);
    }
  }

  static addHyperLinkToEditor(
      {required LinkTextData value,
      required EditorController controller,
      required TextSelection selection,
      required Style selectionStyle}) {
    var index = selection.start;
    var length = selection.end - index;
    if (selectionStyle.attributes[Attribute.link.key]?.value != null) {
      // text should be the link's corresponding text, not selection
      final leaf = controller.quillController.document.querySegmentLeafNode(index).leaf;
      if (leaf != null) {
        final range = getLinkRange(leaf);
        index = range.start;
        length = range.end - range.start;
      }
    }
    controller.quillController.replaceText(index, length, value.text, null);
    controller.quillController.formatText(index, value.text.length, LinkAttribute(value.link));
  }

  static addVideoEmbedToEditor(EditorController controller, KCustomVideoEmbedData embedData) {
    if (embedData.url.isNotEmpty) {
      final index = controller.quillController.selection.baseOffset;
      final length = controller.quillController.selection.extentOffset - index;

      controller.quillController.replaceText(index, length,
          BlockEmbed.custom(KVideoEmbedBlockEmbed(jsonEncode(embedData.toMap()))), null);
      controller.quillController.moveCursorToPosition(index + 1);
      addTextElementToEditor(controller, "\n");
    }
  }

  static modifyEmbed(
      {required EditorController controller, required KCustomVideoEmbedData updatedData}) {
    List<dynamic> deltas = controller.quillController.document.toDelta().toJson();

    int index = deltas.indexWhere((element) {
      if (element['insert'] is Map) {
        Map<String, dynamic> data = element['insert'];
        if (data.containsKey("custom")) {
          String value = data['custom'];
          if (value.contains(updatedData.id)) {
            return true;
          }
        }
      }
      return false;
    });
    if (index != -1) {
      deltas[index] = {
        "insert": {
          "custom": BlockEmbed.custom(KVideoEmbedBlockEmbed(jsonEncode(updatedData.toMap()))).data
        }
      };

      int cursorPosition = controller.quillController.selection.baseOffset;

      controller.quillController.clear();

      controller.quillController.document
          .compose(Document.fromJson(deltas).toDelta(), ChangeSource.local);
      controller.quillController.moveCursorToPosition(cursorPosition);
    }
    // controller.quillController.queryNode(offset)
  }

  static modifyAttachment(
      {required EditorController controller, required KCustomAttachmentData updatedData}) {
    List<dynamic> deltas = controller.quillController.document.toDelta().toJson();

    int index = deltas.indexWhere((element) {
      if (element['insert'] is Map) {
        Map<String, dynamic> data = element['insert'];
        if (data.containsKey("custom")) {
          String value = data['custom'];
          if (value.contains(updatedData.id)) {
            return true;
          }
        }
      }
      return false;
    });
    if (index != -1) {
      deltas[index] = {
        "insert": {
          "custom": BlockEmbed.custom(KAttachmentBlockEmbed(jsonEncode(updatedData.toMap()))).data
        }
      };

      int cursorPosition = controller.quillController.selection.start;

      controller.quillController.clear();

      controller.quillController.document
          .compose(Document.fromJson(deltas).toDelta(), ChangeSource.local);
      controller.quillController.moveCursorToPosition(cursorPosition);
    }
    // controller.quillController.queryNode(offset)
  }

  static addAttachmentToEditor(EditorController controller, KCustomAttachmentData embedData) {
    if (embedData.url.isNotEmpty) {
      final index = controller.quillController.selection.baseOffset;
      final length = controller.quillController.selection.extentOffset - index;

      controller.quillController.replaceText(index, length,
          BlockEmbed.custom(KAttachmentBlockEmbed(jsonEncode(embedData.toMap()))), null);
      controller.quillController.moveCursorToPosition(index + 1);
      addTextElementToEditor(controller, "\n");
    }
  }
}
