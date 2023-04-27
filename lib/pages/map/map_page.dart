import 'package:cade_voce/entities/user_entity.dart';
import 'package:cade_voce/injection/injection_module.dart';
import 'package:cade_voce/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../services/auth_service.dart';


class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _userService = InjectionModule.getIt<UserService>();
  final _authService = InjectionModule.getIt<AuthService>();

  void onError(String errorText){
    showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Text("Ops!"),
        content: Text(errorText),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserEntity?>(
        future: _userService.setupUser(_authService.user.uid, _authService.user.displayName!, onError),
        builder: (context, user) {
          if(user.connectionState == ConnectionState.done){
            if(user.data != null){
              return StreamBuilder<List<UserEntity>>(
                initialData: const <UserEntity>[],
                stream: _userService.streamUsers(),
                builder: (context, users){
                  return Center(
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(_userService.currentUser.position.latitude, _userService.currentUser.position.longitude),
                        zoom: 15,
                      ),
                      myLocationEnabled: true,
                      markers: users.data?.map((e) => Marker(
                        markerId: MarkerId(e.id!),
                        visible: true,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
                        position: LatLng(e.position.latitude, e.position.longitude),
                        infoWindow: InfoWindow(
                          title: e.name,
                          snippet: e.lastUpdate.toString(),
                        ),
                      )).toSet() ?? {},
                    ),
                  );
                },
              );
            }else{
              return const Center(child: Text("Ative o GPS e reinicie seu aplicativo!"),);
            }
          }else{
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
