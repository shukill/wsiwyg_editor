import 'package:flutter_quill/flutter_quill.dart';

class KTheme {
  final QuillIconTheme iconTheme;
  final double iconSize;

  const KTheme({
    required this.iconTheme,
    required this.iconSize,
  });

  KTheme copyWith({
    QuillIconTheme? iconTheme,
    double? iconSize,
  }) {
    return KTheme(
      iconTheme: iconTheme ?? this.iconTheme,
      iconSize: iconSize ?? this.iconSize,
    );
  }
}
