import 'package:random_string/random_string.dart';
import 'package:wysiwyg_editor/core/core.dart';
import 'package:wysiwyg_editor/utils/utils.dart';

class KCustomVideoEmbedData {
  final String id;
  final String url;
  final String? thumbnail;
  final double aspectRatio;
  final String? caption;
  final SizeMode sizeMode;
  final Map<String, dynamic> data;
  final String embedSource;

  static String createID() {
    return "video_embed_${randomAlphaNumeric(14)}";
  }

  bool get isYoutube => embedSource == "youtube";

  String? thumbnailUrl() {
    if (embedSource == "youtube") {
      return KEditorHelperFunctions.getThumbnailURLFromYoutubeUrl(url);
    }
    return null;
  }

  const KCustomVideoEmbedData(
      {required this.id,
      required this.url,
      this.thumbnail,
      this.aspectRatio = 16 / 9,
      this.sizeMode = SizeMode.normal,
      this.caption,
      this.embedSource = "youtube",
      this.data = const {}});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KCustomVideoEmbedData &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          embedSource == other.embedSource &&
          url == other.url &&
          thumbnail == other.thumbnail &&
          aspectRatio == other.aspectRatio &&
          sizeMode == other.sizeMode &&
          data == other.data &&
          caption == other.caption;

  @override
  int get hashCode =>
      id.hashCode ^
      embedSource.hashCode ^
      url.hashCode ^
      thumbnail.hashCode ^
      embedSource.hashCode ^
      sizeMode.hashCode ^
      aspectRatio.hashCode ^
      data.hashCode ^
      caption.hashCode;

  KCustomVideoEmbedData clearCaption() {
    return KCustomVideoEmbedData(
      id: id,
      embedSource: embedSource,
      url: url,
      thumbnail: thumbnail,
      aspectRatio: aspectRatio,
      sizeMode: sizeMode,
      caption: null,
      data: data,
    );
  }

  KCustomVideoEmbedData copyWith({
    String? id,
    String? embedSource,
    String? thumbnail,
    String? url,
    String? extension,
    double? aspectRatio,
    SizeMode? sizeMode,
    KImageAlignment? alignment,
    String? caption,
    Map<String, dynamic>? data,
  }) {
    return KCustomVideoEmbedData(
      id: id ?? this.id,
      embedSource: embedSource ?? this.embedSource,
      url: url ?? this.url,
      thumbnail: thumbnail ?? this.thumbnail,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      sizeMode: sizeMode ?? this.sizeMode,
      caption: caption ?? this.caption,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'embedSource': embedSource,
      'url': url,
      'thumbnail': thumbnail,
      'sizeMode': sizeMode.name,
      'aspectRatio': aspectRatio,
      'caption': caption,
      'data': data,
    };
  }

  factory KCustomVideoEmbedData.fromMap(Map<String, dynamic> map) {
    return KCustomVideoEmbedData(
        id: map['id'] as String,
        embedSource: map['embedSource'] as String,
        url: map['url'] as String,
        thumbnail: map['thumbnail'] as String?,
        aspectRatio: map['aspectRatio'] as double,
        sizeMode: SizeMode.values.firstWhere((element) => element.name == map['sizeMode']),
        caption: map['caption'] as String?,
        data: map['data']);
  }
}
