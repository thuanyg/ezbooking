import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageHelper {
  static Widget loadAssetImage(String imageAssetPath,
      {double? width,
      double? height,
      BorderRadius? radius,
      Color? tintColor,
      Alignment? alignment,
      BoxFit? fit}) {
    return ClipRRect(
      borderRadius: radius ?? BorderRadius.zero,
      child: Image.asset(imageAssetPath,
          width: width,
          height: height,
          fit: fit,
          color: tintColor,
          alignment: alignment ?? Alignment.center),
    );
  }

  static Widget loadNetworkImage(String imageLink,
      {double? width,
      double? height,
      BorderRadius? radius,
      Color? tintColor,
      Alignment alignment = Alignment.center,
      BoxFit? fit}) {
    return ClipRRect(
        borderRadius: radius ?? BorderRadius.zero,
        child: CachedNetworkImage(
          imageUrl: imageLink,
          errorWidget: (context, url, error) =>
              const Center(child: Icon(Icons.error, color: Colors.red)),
          width: width,
          height: height,
          alignment: alignment,
          fit: fit,
        ));
  }
}
