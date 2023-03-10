import 'city.dart';
import 'list.dart';

class GetWeather {
  String? cod;
  int? message;
  int? cnt;
  List<Collection>? list;
  City? city;

  GetWeather({this.cod, this.message, this.cnt, this.list, this.city});

  factory GetWeather.fromJson(Map<String, dynamic> json) => GetWeather(
        cod: json['cod'] as String?,
        message: json['message'] as int?,
        cnt: json['cnt'] as int?,
        list: (json['list'] as List<dynamic>?)
            ?.map((e) => Collection.fromJson(e as Map<String, dynamic>))
            .toList(),
        city: json['city'] == null
            ? null
            : City.fromJson(json['city'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        'cod': cod,
        'message': message,
        'cnt': cnt,
        'list': list?.map((e) => e.toJson()).toList(),
        'city': city?.toJson(),
      };
}
