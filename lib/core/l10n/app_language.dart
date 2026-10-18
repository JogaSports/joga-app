/// Languages the app is available in. English is the default.
enum AppLanguage {
  english('en', 'English'),
  welsh('cy', 'Cymraeg');

  const AppLanguage(this.code, this.nativeName);

  /// BCP-47 code, e.g. for the real app's locale and server-side emails.
  final String code;

  /// Always shown in its own language so people can find it.
  final String nativeName;
}
