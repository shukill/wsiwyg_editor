import 'package:wysiwyg_flutter_quill/flutter_quill.dart';

class KAttachmentBlockEmbed extends CustomBlockEmbed {
  const KAttachmentBlockEmbed(String value) : super(customType, value);
  static const String customType = "we_attachment";
}

class KVideoEmbedBlockEmbed extends CustomBlockEmbed {
  const KVideoEmbedBlockEmbed(String value) : super(customType, value);
  static const String customType = "we_video_embed";
}
