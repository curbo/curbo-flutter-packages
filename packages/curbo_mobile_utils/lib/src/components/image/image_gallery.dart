import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curbo_mobile_utils/curbo_mobile_utils.dart'
    show StringExtension;
import 'package:flutter/material.dart';

class ImageGallery extends StatefulWidget {
  ImageGallery({
    Key? key,
    required this.imageUrls,
    this.autoPlay = false,
    this.enlargeCenterPage = false,
    this.enableInfiniteScroll = false,
    this.viewportFraction = 0.8,
    this.aspectRatio = 16 / 9,
    this.indicatorColor = Colors.blue,
    this.borderIndicatorColor = Colors.grey,
    this.loading,
    this.defaultImage,
    this.fit = BoxFit.cover,
    this.onTap,
  }) : super(key: key);

  final List<String> imageUrls;

  final bool autoPlay;
  final bool enlargeCenterPage;
  final bool enableInfiniteScroll;
  final double viewportFraction;
  final double aspectRatio;
  final Color indicatorColor;
  final Color borderIndicatorColor;
  final Widget? loading;
  final Widget? defaultImage;
  final Function(int)? onTap;
  final BoxFit fit;

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery>
    with TickerProviderStateMixin<ImageGallery> {
  int _currentIndex = 0;

  void onPageChanged(int index, CarouselPageChangedReason reason) {
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

  void _onTap(int index) {
    if (widget.onTap != null) widget.onTap!(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CarouselSlider(
          items: _buildImages(),
          options: CarouselOptions(
            viewportFraction: widget.viewportFraction,
            aspectRatio: widget.aspectRatio,
            autoPlay: widget.autoPlay,
            enlargeCenterPage: widget.enlargeCenterPage,
            enableInfiniteScroll: widget.enableInfiniteScroll,
            onPageChanged: onPageChanged,
          ),
        ),
        _buildIndicator(),
      ],
    );
  }

  List<Widget> _buildImages() {
    List<Widget> children = widget.imageUrls.isNotEmpty
        ? _map<Widget>(
            widget.imageUrls,
            (index, url) {
              final bool isNetworkImage = url.isUrl();

              bool canOpenFile(String path) {
                return File(path).existsSync();
              }

              return InkWell(
                onTap: () => _onTap(index),
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: isNetworkImage
                        ? CachedNetworkImage(
                            imageUrl: url,
                            fit: widget.fit,
                            width: 1000.0,
                            placeholder: (context, url) => Center(
                              child: SizedBox(
                                height: 40,
                                width: 80,
                                child: widget.loading,
                              ),
                            ),
                          )
                        : _buildImageFile(canOpenFile(url), url),
                  ),
                ),
              );
            },
          )
        : [_buildDefaultImage()];

    return children;
  }

  Widget _buildImageFile(
    bool canOpenFile,
    String url,
  ) {
    return canOpenFile
        ? Image.file(
            File(url),
            fit: widget.fit,
            width: 1000.0,
          )
        : _buildDefaultImage();
  }

  Widget _buildDefaultImage() {
    return Container(
      color: Colors.white,
      child: Center(
        child: SizedBox(
          height: 40,
          width: 80,
          child: widget.defaultImage,
        ),
      ),
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
