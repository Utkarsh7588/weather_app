import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather/comman/error.dart';
import 'package:weather/comman/error_controller.dart/error_controller.dart';
import 'package:weather/comman/utils.dart';
import 'package:weather/location/repository/location_repository.dart';

final locationControllerProvider =
    StateNotifierProvider<LocationController, List?>(
        (ref) => LocationController(
              locationRepository: ref.watch(locationRepositoryProvider),
              ref: ref,
            ));

class LocationController extends StateNotifier<List?> {
  final LocationRepository _locationRepository;
  final Ref _ref;
  LocationController(
      {required LocationRepository locationRepository, required Ref ref})
      : _locationRepository = locationRepository,
        _ref = ref,
        super(null);
  void getLocation(BuildContext context) async {
    final res = await _locationRepository.getlocation();
    res.fold(
        (l) => _ref
            .watch(errorControllerProvider.notifier)
            .getError(l.message.toString()),
        (position) => state = position);
  }

  void getLocationByName(BuildContext context, String address) async {
    final res = await _locationRepository.getlocationByName(address);
    res.fold(
        (l) => _ref
            .watch(errorControllerProvider.notifier)
            .getError(l.message.toString()),
        (position) => state = position);
  }
}
