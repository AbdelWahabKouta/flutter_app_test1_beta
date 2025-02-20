import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_test1/APILibraries.dart';
import 'package:flutter_app_test1/FETCH_wdgts.dart';
import 'package:flutter_app_test1/routesGenerator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../configuration.dart';


class MapsPage extends StatefulWidget {
  const MapsPage({Key? key}) : super(key: key);

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  // late BitmapDescriptor customIcon;
  TextEditingController _searchController = TextEditingController();
  final markers = List<Marker>.empty(growable: true);
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();
  Completer<GoogleMapController> _controller = Completer();


  initMarkers() async{
    // BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(5, 5)),
    //     'assets/icon_male.png')
    //     .then((d) {
    //   customIcon = d;
    // });

    markers.clear();
    final data = await initializeMarkers();
    markers.addAll(data);
    setState(() {});
  }

  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission().then((value){
    }).onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR"+error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    //initUser();
    initMarkers();
    super.initState();
  }
  void initUser() async{
    final location = await getUserCurrentLocation();
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        zoom: 15, target: LatLng(location.latitude, location.longitude))));
    setState(() {});
  }
  shortcutMarkers(String type) async{
    markers.clear();
    final data = await Display(type);
    markers.addAll(data);
    setState(() {});
  }

  Widget shortcuts() {
    return ButtonBar(
      mainAxisSize: MainAxisSize.min, // this will take space as minimum as posible(to center)
      children: <Widget>[
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),
          child: new Text('Vets',style: TextStyle(
              color: Colors.black),
          ),
          onPressed: ()  =>  shortcutMarkers('Veterinarian'),
        ),
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),child: new Text('Parks',style: TextStyle(
            color: Colors.black),
        ),
          onPressed: ()  =>  shortcutMarkers('Dog park'),
        ),
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
          ),child: new Text('Pet Stores',style: TextStyle(
            color: Colors.black),
        ),
          onPressed: ()  =>  shortcutMarkers('Pet store'),
        ),
        new ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),
          child: new Text('Meets',style: TextStyle(
              color: Colors.black),
          ),
          onPressed: (){},
        ),
      ],
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: init_appBar(rootNav_key),// CHANGE KEY!!!
      body: Stack(
        children:
        [
          GoogleMap(
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            onTap: (position) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) async {
             // _controller.complete(controller);
              _customInfoWindowController.googleMapController = controller;
            },
            initialCameraPosition: CameraPosition(
                target:LatLng(31.233334,30.033333),zoom: 5.4746

              //    target:LatLng(80,30),zoom: 10.4746,

            ),

            markers: Set<Marker>.of(markers),

          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 212,
            width: 510,
            offset: 50,
          ),
          TextFormField (
            controller: _searchController,
            onChanged: (value){
              print(value);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Search',
            ),),

          Padding(
            padding: const EdgeInsets.fromLTRB(30.0,50.0,30.0,50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: new Text('Vets',style: TextStyle(
                      color: Colors.black),
                  ),
                  onPressed: ()  =>  shortcutMarkers('Veterinarian'),
                ),
                new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),child: new Text('Parks',style: TextStyle(
                    color: Colors.black),
                ),
                  onPressed: ()  =>  shortcutMarkers('Dog park'),
                ),
                new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),child: new Text('Pet Stores',style: TextStyle(
                    color: Colors.black),
                ),
                  onPressed: ()  =>  shortcutMarkers('Pet store'),
                ),
                new ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: new Text('Meets',style: TextStyle(
                      color: Colors.black),
                  ),
                  onPressed: (){},
                ),
              ],
            ),
          ),

          Container(

            alignment:Alignment.bottomCenter,
            child:SizedBox(
              height: 45,
              width: 150,

              child: TextButton(
                  onPressed:(){
                    explore_key.currentState
                        ?.pushNamed('/create_meet');
                    setState(() {});
                  },
                  child: Text("+",style: TextStyle(fontSize: 25, color:Colors.white)),
                  style:ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),

                    shape:MaterialStateProperty.all<CircleBorder>(

                        CircleBorder(
                            side: BorderSide(color:Colors.red)
                        )
                    ),

                  )

              ),
            ),
          ),
        ],

      ),


    );
  }

  Future initializeMarkers() async {
    int ret = -100;
    final  markers = List<Marker>.empty(growable: true);
    try {
      final data = await SupabaseCredentials.supabaseClient
          .from('locations')
          .select('*') as List<dynamic>;

      for (var entry in data){
        final map = Map.from(entry);
        var x = map['longitude'];
        var y =map['latitude'];
        var id = map['id'];
        var title = map['title'];
        var address = map['address'];
        var website = map['website'];
        var phone = map['phone'];
        var thumbnail = map['thumbnail'];
        var type = map['type'];
        markers.add(
            Marker(
                markerId: MarkerId(id.toString()),
                position: LatLng(y, x),
                onTap: () {
                  _customInfoWindowController.addInfoWindow!(
                      Container(
                        decoration:BoxDecoration(
                          color:Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width:510,
                                height:70,
                                decoration: BoxDecoration(

                                  image:DecorationImage(
                                      image:NetworkImage(thumbnail),

                                      fit:BoxFit.fitWidth,
                                      filterQuality: FilterQuality.high
                                  ),  ),),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      title+'\n'+type+'\n'+address
                                          +'\n'+phone+'\n'+website,
                                      style:
                                      Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                        child:SizedBox(
                                          height: 30,

                                          child: new ElevatedButton(onPressed: (){
                                            explore_key.currentState
                                                ?.pushNamed('/location_review');

                                          },
                                              child:new Text('Rate and Review')

                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ]),



                      ), LatLng(y, x)
                  );
                }
            ));
      }
      return markers;
    }
    on PostgrestException catch (error) {
      print(error.message);
    }
    catch (e){
      print(e);
    }
    return List<Marker>.empty();
  }
  Future Display(String type) async {
    int ret = -100;
    final  markers = List<Marker>.empty(growable: true);
    try {
      final data = await SupabaseCredentials.supabaseClient
          .from('locations')
          .select('*').eq('type', type) as List<dynamic>;

      for (var entry in data){
        final map = Map.from(entry);
        var x = map['longitude'];
        var y =map['latitude'];
        var id = map['id'];
        var title = map['title'];
        var address = map['address'];
        var website = map['website'];
        var phone = map['phone'];
        var thumbnail = map['thumbnail'];
        var type = map['type'];
        markers.add(
            Marker(
                markerId: MarkerId(id.toString()),
                position: LatLng(y, x),
                onTap: () {

                  _customInfoWindowController.addInfoWindow!(
                      Container(
                        decoration:BoxDecoration(
                          color:Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width:510,
                                height:70,
                                decoration: BoxDecoration(

                                  image:DecorationImage(
                                      image:NetworkImage(thumbnail),

                                      fit:BoxFit.fitWidth,
                                      filterQuality: FilterQuality.high
                                  ),  ),),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      title+'\n'+type+'\n'+address
                                          +'\n'+phone+'\n'+website+'\n',
                                      style:
                                      Theme
                                          .of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Container(
                                        child:SizedBox(
                                          height: 30,

                                          child: new ElevatedButton(onPressed: (){
                                            explore_key.currentState
                                                ?.pushNamed('/location_review');

                                          },
                                              child:new Text('Rate and Review')

                                          ),
                                        )),

                                  ],
                                ),
                              ),
                            ]),



                      ), LatLng(y, x)
                  );
                }
            ));
      }
      return markers;
    }
    on PostgrestException catch (error) {
      print(error.message);
    }
    catch (e){
      print(e);
    }
    return List<Marker>.empty();
  }
}



