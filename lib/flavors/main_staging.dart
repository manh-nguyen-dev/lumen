import '../bootstrap/bootstrap.dart';
import '../core/widgets/app.dart';
import 'flavor_config.dart';

void main() {
  FlavorConfig.initialize(
    flavor: Flavor.staging,
    name: "Staging",
    baseUrl: "https://api.staging.lumen.com",
    enableDebugTools: true,
  );
  bootstrap(() => const App());
}
