enum Flavor { dev, staging, prod }

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String baseUrl;
  final bool enableDebugTools;

  static late FlavorConfig _instance;

  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.baseUrl,
    required this.enableDebugTools,
  });

  static void initialize({
    required Flavor flavor,
    required String name,
    required String baseUrl,
    required bool enableDebugTools,
  }) {
    _instance = FlavorConfig._internal(
      flavor: flavor,
      name: name,
      baseUrl: baseUrl,
      enableDebugTools: enableDebugTools,
    );
  }

  static FlavorConfig get instance => _instance;
}
