import 'dart:async';
import 'package:demo/common/model/google_address.dart';
import 'package:demo/common/widget/app_loading.dart';
import 'package:demo/common/widget/button.dart';
import 'package:demo/data/service/google/google_map_service.dart';
import 'package:demo/features/home/controller/event_create/event_form_controller.dart';
import 'package:demo/utils/constant/app_colors.dart';
import 'package:demo/utils/constant/sizes.dart';
import 'package:demo/utils/helpers/helpers_utils.dart';
import 'package:demo/utils/helpers/permission_utils.dart';
import 'package:demo/utils/https/https_client.dart';
import 'package:demo/utils/theme/text/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:sizer/sizer.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

class EventSelectMap extends ConsumerStatefulWidget {
  const EventSelectMap({super.key});

  @override
  ConsumerState<EventSelectMap> createState() => EventSelectMapState();
}

class EventSelectMapState extends ConsumerState<EventSelectMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng? mapPosition;
  bool isCameraMoving = false;
  GoogleAddress? tempAddress;
  bool isFetching = true;

  static late CameraPosition initMap;
  @override
  void initState() {
    if (mounted) {
      requestCurrentLocation();
    }
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

  Future<void> checkLocationPermission() async {
    perm.PermissionStatus status = await perm.Permission.location.request();
    debugPrint("Permission is ${status}");
    if (status.isGranted && mounted) {
      debugPrint("Location permission granted!");
    } else if (status.isDenied && mounted) {
      HelpersUtils.navigatorState(context).pop();
    } else if (status.isPermanentlyDenied && mounted) {
      HelpersUtils.navigatorState(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.,
        foregroundColor: AppColors.backgroundLight,
        automaticallyImplyLeading: true,
        leading: IconButton(
            onPressed: () {
              HelpersUtils.navigatorState(context).pop();
            },
            icon: const Icon(Icons.close)),
      ),
      body: mapPosition == null ? renderLoading() : renderMap(context),
    );
  }

  Widget renderLoading() {
    return appLoadingSpinner();
  }

  Stack renderMap(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          // height: ,
          child: GoogleMap(
            initialCameraPosition: initMap,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            myLocationButtonEnabled: false,
            myLocationEnabled: false,
            onCameraMoveStarted: () {
              setState(() {
                isCameraMoving = true;
                isFetching = true;
              });
            },
            onCameraIdle: () {
              if (mounted) {
                setState(() {
                  isCameraMoving = false;
                });
              }

              WidgetsBinding.instance.addPostFrameCallback(
                (timeStamp) {
                  final lat = ref.read(eventFormControllerProvider).lat;
                  final lng = ref.read(eventFormControllerProvider).lng;
                  mapPosition?.latitude == lat
                      ? getAddressess(lat: lat, lng: lng)
                      : getAddressess();
                },
              );
            },
            onCameraMove: (position) {
              setState(() {
                mapPosition =
                    LatLng(position.target.latitude, position.target.longitude);
              });
            },
            markers: {
              Marker(
                  markerId: const MarkerId('Default'),
                  infoWindow: InfoWindow(
                    title: tempAddress?.address ?? "Select",
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
        Positioned(
          bottom: 0,
          child: Container(
            width: 100.w,
            padding: const EdgeInsets.all(Sizes.xxl),
            height: 230,
            decoration: const BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Sizes.xxl),
                  topRight: Radius.circular(Sizes.xxl),
                )),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined),
                    const SizedBox(
                      width: Sizes.lg,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 70.w,
                          child: Text(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            tempAddress?.address ?? "",
                            style: AppTextTheme.lightTextTheme.bodyMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(tempAddress?.country ?? ""),
                      ],
                    )
                  ],
                ),
                const Spacer(),
                const Divider(
                  color: AppColors.neutralColor,
                ),
                const SizedBox(
                  height: Sizes.xxl,
                ),
                isCameraMoving || isFetching
                    ? Padding(
                        padding: const EdgeInsets.all(15.5),
                        child: appLoadingSpinner())
                    : ButtonApp(
                        label: 'Save Changes',
                        height: 20,
                        color: AppColors.secondaryColor,
                        textStyle: AppTextTheme.lightTextTheme.titleMedium!
                            .copyWith(
                                color: AppColors.backgroundLight,
                                fontWeight: FontWeight.w600),
                        splashColor: AppColors.backgroundLight,
                        onPressed: () {
                          ref
                              .read(eventFormControllerProvider.notifier)
                              .updateAddressMap(
                                  address:
                                      '${tempAddress?.address} ${tempAddress?.country}',
                                  lat: mapPosition!.latitude,
                                  lng: mapPosition!.longitude);
                          HelpersUtils.navigatorState(context).pop();
                        },
                      ),
                const SizedBox(
                  height: Sizes.md,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Future getAddressess({double? lat, double? lng}) async {
    try {
      final googleMapservice = GoogleMapService(httpsClient: HttpsClient());
      final result = await googleMapservice.getAddressFromLatLng(
          lat ?? mapPosition!.latitude, lng ?? mapPosition!.longitude);

      if (mounted) {
        setState(() {
          isFetching = false;
          tempAddress = result;
        });
      }
    } catch (e) {
      // HelpersUtils.navigatorState(context).pop();
      // Fluttertoast.showToast(
      //     msg: e.toString(),
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 5,
      //     backgroundColor: AppColors.errorColor,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }
  }

  void requestCurrentLocation() async {
    // ref.read(appLoadingStateProvider.notifier).setState(true);
    try {
      final lat = ref.read(eventFormControllerProvider).lat;
      final lng = ref.read(eventFormControllerProvider).lng;
      LocationData? position;
      if (lat == null && lng == null) {
        position = await HelpersUtils.getCurrentLocation();

        initMap = CameraPosition(
          target: LatLng(
              position.latitude ?? 11.5564, position.longitude ?? 104.9282),
          zoom: 14,
        );
      } else {
        initMap = CameraPosition(
          target: LatLng(lat!, lng!),
          zoom: 14,
        );
      }

      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          setState(() {
            mapPosition = LatLng(lat ?? position!.latitude ?? 11.5564,
                lng ?? position!.longitude ?? 104.9282);
          });
        },
      );
    } catch (e) {
      if (mounted && e.toString().startsWith('Location permissions')) {
        PermissionUtils.showPermissionDialog(
            context, 'Location Permission', e.toString(), false);
      }
    }
  }
}
