import 'package:cade_voce/services/position_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../entities/user_entity.dart';

class UserService {
  final FirebaseFirestore firestore;
  final PositionService positionService;
  late UserEntity _currentUser;

  UserService(this.firestore, this.positionService);

  Future<void> updateUser(UserEntity user) async {
    await firestore.collection('users').doc(user.id).update(user.toMap());
  }

  Future<void> createUser(UserEntity user) async {
    await firestore.collection('users').add(user.toMap());
  }

  Future<UserEntity?> readUserByUid(String uid) async {
    final userDoc =
        await firestore.collection('users').where('uid', isEqualTo: uid).get();
    if (userDoc.docs.isNotEmpty) {
      return UserEntity.fromMap(
          userDoc.docs.first.data(), userDoc.docs.first.id);
    }
    return null;
  }

  Stream<List<UserEntity>> streamUsers() {
    final usersDocs = firestore.collection('users').snapshots();
    return usersDocs.map((snapshot) => snapshot.docs
        .map((doc) => UserEntity.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<UserEntity?> setupUser(String uid, String userName, void Function(String) onError) async {
    try{
      UserEntity? user = await readUserByUid(uid);
      final position = await positionService.getDeviceLocation();
      if(user != null){
        if(user.lastUpdate.isBefore(_oneHourAgo)){
          user.lastUpdate = DateTime.now();
          await updateUser(user);
        }
      }else{
        user = UserEntity(id: null, uid: uid, name: userName, position: position!, lastUpdate: DateTime.now());
        await createUser(user);
      }
      _currentUser = user;
      return user;
    }catch(e){
      if(e.runtimeType == PlatformException) onError("Um erro ocorreu, verifique se seu GPS está ativado!");
    }
    return null;
  }

  DateTime get _oneHourAgo => DateTime.now().subtract(const Duration(hours: 1));

  UserEntity get currentUser => _currentUser;
}
