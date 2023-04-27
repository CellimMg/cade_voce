class PositionEntity{
   double latitude;
   double longitude;

  PositionEntity({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toMap(){
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory PositionEntity.fromMap(Map<String, dynamic> map){
    return PositionEntity(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  factory PositionEntity.fromMethodChannel(Map<dynamic, dynamic> map){
    return PositionEntity(
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }
}