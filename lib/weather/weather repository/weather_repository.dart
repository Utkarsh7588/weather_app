import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:weather/comman/typedef.dart';
import 'package:http/http.dart' as http;
import 'package:weather/weather/api/api_constants.dart';

import '../../comman/faliure.dart';
import '../../models/response model/get_weather.dart';

final weatherRepositoryProvider = Provider((ref) => WeatherRepository());

class WeatherRepository {
  FutureEither<GetWeather> getWeatherData(
      double lat, double lon, String scale) async {
    try {
      String url = '${apihost}appid=$apiKey&lat=$lat&lon=$lon&units=$scale';
      Uri weatherUri = Uri.parse(url);
      http.Response response = await http.get(weatherUri);
      var jsonString = jsonDecode(response.body);
      GetWeather weatherData = GetWeather.fromJson(jsonString);
      return right(weatherData);
    } catch (e) {
      if (e is SocketException) {
        //treat SocketException
        return left(Failure(e.message.toString()));
      } else if (e is TimeoutException) {
        return left(Failure(e.message.toString()));
      } else {
        return left(Failure(e.toString()));
      }
    }
  }
}
