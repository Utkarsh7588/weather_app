import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/location/controller/location_controller.dart';
import 'package:weather/models/response%20model/get_weather.dart';
import 'package:weather/comman/error_controller.dart/error_controller.dart';

import 'package:weather/weather/weather%20repository/weather_repository.dart';

GetWeather initialState = GetWeather();
final weatherControllerProvider =
    StateNotifierProvider<WeatherController, GetWeather>(
  (ref) => WeatherController(
    weatherRepository: ref.watch(weatherRepositoryProvider),
    ref: ref,
  ),
);

class WeatherController extends StateNotifier<GetWeather> {
  final WeatherRepository _weatherRepository;
  final Ref _ref;

  // final LocationController _locationController;
  WeatherController({
    required WeatherRepository weatherRepository,
    required Ref ref,
    // required LocationController locationController
  })  : _weatherRepository = weatherRepository,
        _ref = ref,
        // _locationController = locationController,
        super(initialState);

  void getWeatherData(BuildContext context, String scale) async {
    final position = _ref.watch(locationControllerProvider.notifier).state!;
    final res = await _weatherRepository.getWeatherData(
        position[0], position[1], scale);

    res.fold(
        (l) => _ref
            .watch(errorControllerProvider.notifier)
            .getError(l.message.toString()),
        (weather) => state = weather);
  }
}
