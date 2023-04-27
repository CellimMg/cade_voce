import 'package:cade_voce/entities/position_entity.dart';

class UserEntity{
  final String? id;
  final String uid;
  String name;
  PositionEntity position;
  DateTime lastUpdate;

  UserEntity({required this.id, required this.uid, required this.name, required this.position, required this.lastUpdate});

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'uid': uid,
      'position': position.toMap(),
      'lastUpdate': lastUpdate,
    };
  }

  factory UserEntity.fromMap(Map<String, dynamic> map, String id){
    return UserEntity(
      id: id,
      uid: map['uid'],
      name: map['name'],
      position: PositionEntity.fromMap(map['position']),
      lastUpdate: map['lastUpdate'].toDate(),
    );
  }
}