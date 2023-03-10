import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/comman/faliure.dart';
import 'package:weather/comman/typedef.dart';

final locationRepositoryProvider = Provider((ref) => LocationRepository());

class LocationRepository {
  List? position;
  FutureEither<List?> getlocation() async {
    try {
      LocationPermission permission;
      bool serviceEnabled;
      permission = await Geolocator.checkPermission();
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
            'Location permissions are permanently denied, we cannot request permissions.');
      }
      Position pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      position = [pos.latitude, pos.longitude];
      return right(position);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<List?> getlocationByName(address) async {
    try {
      List<Location> pos = await locationFromAddress(address);
      position = [pos[0].latitude, pos[0].longitude];
      return right(position);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
