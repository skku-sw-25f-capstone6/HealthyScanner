class UrlResolver {
  static String resolve(String baseHost, String raw) {
    final p = raw.trim();
    if (p.isEmpty) return p;

    if (p.startsWith('http://') || p.startsWith('https://')) return p;

    final normalizedPath = p.startsWith('static/') ? '/$p' : p;

    return Uri.https(baseHost, normalizedPath).toString();
  }
}
