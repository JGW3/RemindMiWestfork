import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:remindmi/constants/images.dart';

class CustomCachedNetworkImage extends StatelessWidget {
  const CustomCachedNetworkImage({
    required this.url,
    required this.fit,
    this.height,
    this.width,
    this.color,
    this.placeholder,
    this.placeholderFit,
  });

  final String url;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? placeholderFit;
  final String? placeholder;
  @override
  Widget build(BuildContext context) {
    final String _url = url;
    return CachedNetworkImage(
      imageUrl: _url,
      fit: fit,
      height: height,
      width: width,
      color: color,
      alignment: Alignment.topCenter,
      errorWidget: (a, b, c) => Image.asset(
        Images.remindmiIcon,
        fit: placeholderFit ?? fit,
        height: height,
        width: width,
      ),
      placeholder: (a, c) => Image.asset(
        placeholder ?? Images.remindmiIcon,
        fit: placeholderFit ?? fit,
        height: height,
        width: width,
      ),
    );
  }
}
