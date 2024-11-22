import 'package:get_it/get_it.dart';
import 'package:weather_app/API/Client/API_client.dart';
import 'package:weather_app/Repo/WeatherRepo.dart';
import 'package:weather_app/API/Service/WeatherService.dart';
import 'package:weather_app/Provider/location_provider.dart';

final locator = GetIt.instance;

Future<void> setupLoctor() async {
  locator.registerLazySingleton(() => ApiClient());
  locator.registerLazySingleton(() => Weatherservice(locator<ApiClient>()));
  locator.registerLazySingleton(() => WeatherRepo(locator<Weatherservice>()));

  locator.registerFactory(() => LocationProvider(locator<WeatherRepo>()));

  LocationProvider(WeatherRepo(Weatherservice(ApiClient())));
}
