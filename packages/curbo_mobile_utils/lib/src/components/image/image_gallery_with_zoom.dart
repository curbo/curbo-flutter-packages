import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:curbo_mobile_utils/curbo_mobile_utils.dart'
    show StringExtension;

class ImageGalleryWithZoom extends StatefulWidget {
  ImageGalleryWithZoom({
    Key? key,
    this.loadingBuilder,
    this.backgroundDecoration = const BoxDecoration(color: Colors.transparent),
    this.minScale,
    this.maxScale,
    this.initialIndex = 0,
    this.indicatorColor = Colors.blue,
    this.borderIndicatorColor = Colors.grey,
    required this.imageUrls,
    this.scrollDirection = Axis.horizontal,
    this.defaultImage,
  })  : pageController = PageController(
          initialPage: initialIndex ?? 0,
        ),
        super(key: key);

  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int? initialIndex;
  final PageController pageController;
  final List<String> imageUrls;
  final Axis scrollDirection;
  final Color indicatorColor;
  final Color borderIndicatorColor;
  final String? defaultImage;

  @override
  _ImageGalleryWithZoomState createState() => _ImageGalleryWithZoomState();
}

class _ImageGalleryWithZoomState extends State<ImageGalleryWithZoom> {
  int _currentIndex = 0;

  @override
  void initState() {
    _currentIndex = widget.initialIndex ?? 0;

    super.initState();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<T> _map<T>(List<String> images, Function(int, String) handler) {
    List<T> result = [];
    for (var i = 0; i < images.length; i++) {
      result.add(handler(i, images[i]));
    }

    return result;
  }

  T? _getImageProvider<T extends ImageProvider>(int index) {
    final String url = widget.imageUrls[index];

    final bool isNetworkImage = url.isUrl();

    bool canOpenFile(String path) {
      return File(path).existsSync();
    }

    if (isNetworkImage) return CachedNetworkImageProvider(url) as T?;

    return canOpenFile(url)
        ? FileImage(File(url)) as T?
        : AssetImage(widget.defaultImage!) as T?;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: _buildItem,
            itemCount: widget.imageUrls.length,
            loadingBuilder: widget.loadingBuilder,
            backgroundDecoration: widget.backgroundDecoration,
            pageController: widget.pageController,
            onPageChanged: onPageChanged,
            scrollDirection: widget.scrollDirection,
          ),
        ),
        _buildIndicator(),
      ],
    );
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final heroTag = 'image_$index';

    return PhotoViewGalleryPageOptions(
      imageProvider: _getImageProvider(index),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.covered * 1.1,
      heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
    );
  }

  Widget _buildIndicator() {
    return Container(
      height: 64.0,
      alignment: Alignment.center,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        primary: false,
        children: _map<Widget>(
          widget.imageUrls,
          (index, _) {
            final isCurrent = _currentIndex == index;

            final size = isCurrent ? 14.0 : 8.0;
            final boderSize = isCurrent ? 4.0 : 2.0;
            final borderColor =
                isCurrent ? widget.indicatorColor : widget.borderIndicatorColor;

            return AnimatedContainer(
              width: size,
              height: size,
              duration: Duration(milliseconds: 250),
              margin: EdgeInsets.symmetric(vertical: 24.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: boderSize),
                color: _currentIndex == index
                    ? Colors.white
                    : widget.borderIndicatorColor,
              ),
            );
          },
        ),
      ),
    );
  }
}
