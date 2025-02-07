import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../utils/enum/svg_enum.dart';

class AppSvgWidget extends StatelessWidget {
  final String svgPath;
  final double? width, height;
  final Enum svgType;
  final File? file;
  final Uint8List? bytes;
  final String? url;
  final Color? color;
  const AppSvgWidget({super.key, required this.svgPath, this.width = 8, this.height = 8, required this.svgType, this.file, this.bytes, this.url, this.color,});

  @override
  Widget build(BuildContext context) {
    switch (svgType) {
      case SvgType.asset:
        return SvgPicture.asset(svgPath, width: width, height: height, color: color,);
      case SvgType.memory:
        return SvgPicture.memory(bytes!, width: width, height: height, color: color,);
      case SvgType.network:
        return SvgPicture.network(url ?? "", width: width, height: height, color: color,);
      case SvgType.string:
        return SvgPicture.string(url ?? "", width: width, height: height, color: color,);
  }
  return SizedBox.shrink();
  }
}
