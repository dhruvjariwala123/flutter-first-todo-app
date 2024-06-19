import 'package:flutter/material.dart';

enum DeviceType { mobile, desktop }

DeviceType getDeviceType(BuildContext context) {
  final DeviceType deviceType;
  final deviceWidth = MediaQuery.of(context).size.width;
  if (deviceWidth < 800) {
    deviceType = DeviceType.mobile;
  } else {
    deviceType = DeviceType.desktop;
  }
  return deviceType;
}
