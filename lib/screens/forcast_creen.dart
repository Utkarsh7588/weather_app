import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/weather/weather%20controller/weather_controller.dart';

import '../models/response model/get_weather.dart';

class ForecastScreen extends ConsumerWidget {
  const ForecastScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    GetWeather weatherData = ref.watch(weatherControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(weatherData.city!.name!),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: weatherData.list!.length,
            itemBuilder: (BuildContext context, int index) {
              final list = weatherData.list!;
              return ListTile(
                leading: Text(list[index].dtTxt!),
                trailing: Column(
                  children: [
                    const SizedBox(
                      height: 9,
                    ),
                    Text('max Temp:${list[index].main!.tempMax!}'),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('min Temp:${list[index].main!.tempMin!}')
                  ],
                ),
                title: Text('${list[index].weather![0].description}'),
              );
            }),
      ),
    );
  }
}
