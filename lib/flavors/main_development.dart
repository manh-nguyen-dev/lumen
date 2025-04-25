import 'package:lumen/bootstrap/bootstrap.dart';

import '../core/widgets/app.dart';
import 'flavor_config.dart';

void main() {
  FlavorConfig.initialize(
    flavor: Flavor.dev,
    name: "Development",
    baseUrl: "https://api.dev.lumen.com",
    enableDebugTools: true,
  );
  bootstrap(() => const App());
}
