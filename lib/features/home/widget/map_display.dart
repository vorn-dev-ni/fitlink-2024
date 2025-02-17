import 'dart:async';

import 'package:demo/utils/constant/sizes.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MapDisplayLocation extends StatefulWidget {
  final double? lat;
  final double? lng;
  final locationTitle;
  const MapDisplayLocation(
      {super.key, this.lat, this.lng, this.locationTitle = ""});

  @override
  State<MapDisplayLocation> createState() => MapDisplayLocationState();
}

class MapDisplayLocationState extends State<MapDisplayLocation> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  CameraPosition? _currentMapPoint;
  LatLng? mapPosition;
  @override
  void initState() {
    bindingLocation(widget.lat ?? 40.712776, widget.lng ?? -74.005974);
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _controller.future.then(
        (value) => value.dispose(),
      );
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return mapPosition == null
        ? loadingMapSkeleton()
        : SizedBox(
            width: 90.w,
            height: 200,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Sizes.md),
              child: GoogleMap(
                myLocationButtonEnabled: false,
                myLocationEnabled: true,
                initialCameraPosition: _currentMapPoint!,
                markers: {
                  Marker(
                      markerId: const MarkerId('Event Location'),
                      infoWindow: InfoWindow(
                        title: widget.locationTitle ?? 'Event Location',
                      ),
                      position: mapPosition!,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure)),
                },
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          );
  }

  Widget loadingMapSkeleton() {
    return Skeletonizer(
        enabled: true,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Sizes.md),
          child: Container(
            width: double.maxFinite,
            color: Colors.red,
            height: 200,
          ),
        ));
  }

  void bindingLocation(double lat, double lng) {
    _currentMapPoint = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 15,
    );
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            setState(() {
              mapPosition = LatLng(lat, lng);
            });
          },
        );
      },
    );
  }
}
