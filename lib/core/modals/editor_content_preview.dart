class EditorContentPreview {
  final List<dynamic> content;
  final bool isOriginal;

  const EditorContentPreview({
    required this.content,
    required this.isOriginal,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'isOriginal': isOriginal,
    };
  }

  factory EditorContentPreview.fromMap(Map<String, dynamic> map) {
    return EditorContentPreview(
      content: List<dynamic>.from(map['content']),
      isOriginal: map['isOriginal'] as bool,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EditorContentPreview &&
          runtimeType == other.runtimeType &&
          content == other.content &&
          isOriginal == other.isOriginal;

  @override
  int get hashCode => content.hashCode ^ isOriginal.hashCode;
}
