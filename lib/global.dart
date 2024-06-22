import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mmu_driver/MainScreen/driver_data.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentUser;
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;
//UserModel? userModelCurrentInfo;
Position? driverCurrentPosition;
//DirectionDetailsInfo? tripDirectionDetailsInfo;
String userDestinationAddress = " ";
DriverData onlineDriverData = DriverData();
String? driverVehicleType = " ";
