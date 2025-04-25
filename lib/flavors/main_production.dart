import '../bootstrap/bootstrap.dart';
import '../core/widgets/app.dart';
import 'flavor_config.dart';

void main() {
  FlavorConfig.initialize(
    flavor: Flavor.prod,
    name: "Production",
    baseUrl: "https://api.lumen.com",
    enableDebugTools: false,
  );
  bootstrap(() => const App());
}
