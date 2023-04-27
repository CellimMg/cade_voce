import 'package:flutter/services.dart';

import '../entities/position_entity.dart';

class PositionService {
  final _locationChannel = const MethodChannel('locationChannel');

  Future<PositionEntity?> getDeviceLocation() async {
    final result = await _locationChannel.invokeMethod('getCurrentLocation');
    final position = PositionEntity.fromMethodChannel(result);
    return position;
  }

  Future<bool> enableGPS() async {
    final result = await _locationChannel.invokeMethod('enableGPS');
    return result;
  }
}
