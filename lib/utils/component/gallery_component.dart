import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../app_scaffold.dart';
import 'cached_image_widget.dart';

class GalleryComponent extends StatelessWidget {
  final List<String> images;
  final int index;
  final int? padding;
  final double? height;
  final double? width;

  GalleryComponent({required this.images, required this.index, this.padding, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ZoomImageScreen(galleryImages: images, index: index).launch(context, pageRouteAnimation: PageRouteAnimation.Fade, duration: 200.milliseconds);
      },
      child: CachedImageWidget(
        url: images[index],
        height: height ?? 100,
        width: width ?? (context.width() / 3 - (padding ?? 22)),
        fit: BoxFit.fill,
        radius: defaultRadius,
      ),
    );
  }
}

class ZoomImageScreen extends StatefulWidget {
  final int index;
  final List<String>? galleryImages;

  ZoomImageScreen({required this.index, this.galleryImages});

  @override
  _ZoomImageScreenState createState() => _ZoomImageScreenState();
}

class _ZoomImageScreenState extends State<ZoomImageScreen> {
  bool showAppBar = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hasLeadingWidget: true,
      appBarBackgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          setState(() {
            showAppBar = !showAppBar;
          });
        },
        child: PhotoViewGallery.builder(
          scrollPhysics: BouncingScrollPhysics(),
          backgroundDecoration: BoxDecoration(color: context.scaffoldBackgroundColor),
          pageController: PageController(initialPage: widget.index),
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              imageProvider: CachedNetworkImageProvider(widget.galleryImages![index]),
              initialScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained,
              heroAttributes: PhotoViewHeroAttributes(tag: widget.galleryImages![index]),
            );
          },
          itemCount: widget.galleryImages!.length,
          loadingBuilder: (context, event) => Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}