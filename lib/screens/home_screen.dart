import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/comman/erroe_text.dart';
import 'package:weather/comman/loader.dart';
import 'package:weather/models/response%20model/get_weather.dart';
import 'package:weather/comman/error_controller.dart/error_controller.dart';
import 'package:weather/router.dart';

import 'package:weather/weather/weather%20controller/weather_controller.dart';

import '../location/controller/location_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool unit = true;
  var count = 0;
  bool isloading = false;
  TextEditingController controller = TextEditingController();
  void getWeatherDataBysearch(context, ref, String address) async {
    await ref
        .read(locationControllerProvider.notifier)
        .getLocationByName(context, address);
    String scale = unit ? 'metric' : 'imperial';
    ref.read(weatherControllerProvider.notifier).getWeatherData(context, scale);
  }

  void getWeatherData(context, ref) async {
    await ref.read(locationControllerProvider.notifier).getLocation(context);
    String scale = unit ? 'metric' : 'imperial';
    ref.read(weatherControllerProvider.notifier).getWeatherData(context, scale);
  }

  void navigateToForecastScreen() {
    Navigator.of(context).pushNamed(forecastScreenRoute);
  }

  @override
  Widget build(BuildContext context) {
    GetWeather weatherData = ref.watch(weatherControllerProvider);
    String? errorMessage = ref.watch(errorControllerProvider);
    if (weatherData == initialState) {
      if (count == 0) {
        Future.delayed(const Duration(milliseconds: 50),
            () => getWeatherData(context, ref));
        count++;
      }
      return Scaffold(
          appBar: AppBar(
            title: const Text('☀️'),
            actions: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: 'search'),
                  enableSuggestions: true,
                  autocorrect: false,
                  keyboardType: TextInputType.streetAddress,
                  textAlign: TextAlign.center,
                  onSubmitted: (value) {
                    getWeatherDataBysearch(context, ref, value);
                  },
                ),
              ),
              IconButton(
                  onPressed: () {
                    getWeatherDataBysearch(context, ref, controller.text);
                  },
                  icon: const Icon(Icons.search)),
              Center(
                child: unit ? const Text('Celius') : const Text('Faranite'),
              ),
              Switch(
                value: unit,
                onChanged: ((value) {
                  unit = value;
                  getWeatherData(context, ref);
                }),
              ),
            ],
          ),
          body: Center(
              child: errorMessage == null
                  ? const Loader()
                  : ErrorText(error: errorMessage)));
    } else {
      return Scaffold(
          appBar: AppBar(
            title: const Text('☀️'),
            actions: [
              SizedBox(
                  width: 200,
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'search'),
                    enableSuggestions: true,
                    autocorrect: false,
                    keyboardType: TextInputType.streetAddress,
                    textAlign: TextAlign.center,
                    onSubmitted: (address) {
                      getWeatherDataBysearch(context, ref, address);
                    },
                  )),
              IconButton(
                  onPressed: () {
                    getWeatherDataBysearch(context, ref, controller.text);
                  },
                  icon: const Icon(Icons.search)),
              Center(
                child: unit ? const Text('Celius') : const Text('Faranite'),
              ),
              Switch(
                  value: unit,
                  onChanged: ((value) {
                    unit = value;
                    getWeatherData(context, ref);
                  })),
            ],
          ),
          body: errorMessage == null
              ? Column(
                  children: [
                    Text(weatherData.city!.name!),
                    const SizedBox(
                      height: 20,
                    ),
                    Text('temp: ${weatherData.list![0].main!.temp!}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('humidity: ${weatherData.list![0].main!.humidity!}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('wind speed: ${weatherData.list![0].wind!.speed!}'),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                        'description: ${weatherData.list![0].weather![0].description!}'),
                    const SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      onPressed: () => navigateToForecastScreen(),
                      child: const Text('check forecast'),
                    )
                  ],
                )
              : ErrorText(error: errorMessage));
    }
  }
}
