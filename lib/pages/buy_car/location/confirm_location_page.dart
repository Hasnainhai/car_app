import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:fl_carmax/utils/constant.dart';
import 'package:fl_carmax/utils/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/language_constant.dart';

class ConfirmLocationPage extends StatefulWidget {
  const ConfirmLocationPage({Key? key}) : super(key: key);

  @override
  State<ConfirmLocationPage> createState() => _ConfirmLocationPageState();
}

List locationList = [
  {
    'address': '2715 Ash Dr. San Jose, South Dakota 83475',
    'distance': '1.4 km',
  },
];
List<Marker> _markers = [];
List _imageList = [
  mapLocation,
  mapLocation,
  mapLocation,
];
final List<LatLng> _latlng = [
  const LatLng(37.763597, -122.417394),
  const LatLng(37.784252, -122.414303),
  const LatLng(37.756385, -122.408876),
];

class _ConfirmLocationPageState extends State<ConfirmLocationPage> {
  List globalKeys = List.generate(3, (index) => GlobalKey());
  int _selectedLocation = 0;
  final _scrollController = ScrollController();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _sourceLocation =
      CameraPosition(target: LatLng(37.785591, -122.406331), zoom: 13.5);
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    for (int i = 0; i < _imageList.length; i++) {
      final Uint8List markerIcon = await getBytesFromAssets(_imageList[i], 110);
      _markers.add(
        Marker(
          icon: BitmapDescriptor.fromBytes(markerIcon),
          markerId: MarkerId(i.toString()),
          position: _latlng[i],
          onTap: () async {
            setState(() => _selectedLocation = i);
            _scrollController.position.ensureVisible(
              globalKeys[i].currentContext!.findRenderObject()!,
              alignment: 0.5,
            );
          },
        ),
      );
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<Uint8List> getBytesFromAssets(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _sourceLocation,
            markers: Set<Marker>.of(_markers),
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          backIconMethod(context),
          Positioned(
              bottom: 0,
              child: SizedBox(
                height: 210,
                width: 100.w,
                child: Row(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: 123,
                          width: 100.w,
                          child: ListView(
                            controller: _scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            scrollDirection: Axis.horizontal,
                            children: List.generate(3, (index) {
                              bool isSelected = _selectedLocation == index;
                              return GestureDetector(
                                onTap: () async {
                                  setState(() => _selectedLocation = index);
                                  GoogleMapController controller =
                                      await _controller.future;
                                  controller.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              target: _latlng[index],
                                              zoom: 13.5)));
                                },
                                child: Container(
                                  key: globalKeys[index],
                                  margin: index == 0
                                      ? const EdgeInsets.only(right: 10)
                                      : index == 2
                                          ? const EdgeInsets.only(left: 10)
                                          : const EdgeInsets.symmetric(
                                              horizontal: 10),
                                  padding: const EdgeInsets.fromLTRB(12, 16, 15, 16),
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius: myBorderRadius10,
                                    border: isSelected
                                        ? Border.all(color: primaryColor)
                                        : null,
                                    boxShadow: isSelected
                                        ? [myPrimaryShadow]
                                        : [myBoxShadow],
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.location_on_rounded,
                                          color: primaryColor),
                                      widthSpace10,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 40.w,
                                            child: Text(
                                                '2715 Ash Dr. San Jose, South Dakota 83475',
                                                style: colorA6Medium14),
                                          ),
                                          Text('1.4 km',
                                              style: primaryMedium14),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        heightSpace15,
                        SizedBox(
                            width: 90.w,
                            child: PrimaryButton(
                              title: translation(context).confirmLocation,
                              onTap: () => Navigator.pop(context),
                            ))
                      ],
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Positioned backIconMethod(BuildContext context) {
    return Positioned(
        top: Platform.isIOS ? 65 : 35,
        child: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ));
  }
}
