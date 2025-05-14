import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:moodiary/utils/loaders/shimmer_effect.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class TCircularImage extends StatelessWidget {
  const TCircularImage({
    super.key,
    this.fit = BoxFit.cover,
    required this.image,
    this.isNetworkImage = false,
    this.overlayColor,
    this.backgroundColor,
    this.width = 56,
    this.height = 56,
    this.padding = TSizes.sm,
    this.errorWidget, 
    this.placeholderWidget, 
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  final Widget Function(BuildContext, String)? placeholderWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: isNetworkImage ? EdgeInsets.zero : EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ??
            (THelperFunctions.isDarkMode(context)
                ? TColors.black
                : TColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: ClipRRect(
          // Add ClipRRect to make the image circular
          borderRadius: BorderRadius.circular(100),
          child: isNetworkImage
              ? CachedNetworkImage(
                  imageUrl: image,
                  fit: fit,
                  color: overlayColor,
                  placeholder: placeholderWidget ??
                      (context, url) => TShimmerEffect(
                            width: width,
                            height: height,
                          ),
                  errorWidget: errorWidget ??
                      (context, url, error) => Image.asset(
                            TImages.colleague,
                            fit: fit,
                            color: overlayColor,
                          ),
                )
              : Image(
                  fit: fit,
                  image: AssetImage(image),
                  color: overlayColor,
                ),
        ),
      ),
    );
  }
}
