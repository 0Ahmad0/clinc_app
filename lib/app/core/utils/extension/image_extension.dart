

import '../app_url.dart';

extension UrlFixer on String {
  String withBase() {
    if (isEmpty) return "";

    final lower = toLowerCase();

    if (lower.startsWith("http://") || lower.startsWith("https://")) {
      return this;
    }

    return "$baseServSlashLess$this";
  }

  String withStorage() {
    if (isEmpty) return "";

    final lower = toLowerCase();

    if (lower.startsWith("http://") || lower.startsWith("https://")) {
      return this;
    }

    if (startsWith("/storage") || contains("/storage")) {
      return "$baseServSlashLess$this";
    }

    return "$storageUrl$this";
  }
}
