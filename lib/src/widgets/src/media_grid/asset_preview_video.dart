import 'dart:io';

import 'package:dismissible_page/dismissible_page.dart';
import 'package:fast_media_picker/src/cubit/media_picker_cubit.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';

import '../asset_thumbnail_image.dart';

class AssetPreviewVideo extends StatefulWidget {
  const AssetPreviewVideo({
    super.key,
    required this.asset,
    required this.cubit,
    required this.fromWidth,
    required this.fromHeight,
  });
  final MediaPickerCubit cubit;
  final AssetEntity asset;
  final double fromWidth;
  final double fromHeight;

  @override
  State<AssetPreviewVideo> createState() => _AssetPreviewVideoState();
}

class _AssetPreviewVideoState extends State<AssetPreviewVideo> {
  VideoPlayerController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initVideo();
  }

  initVideo() async {
    final file = await widget.asset.file;
    if (file == null) return;
    _controller = VideoPlayerController.file(file);
    _controller!.initialize().then((_) {
      if (mounted) {
        setState(() {});
        _controller!.play();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
      onDismissed: () {
        Navigator.of(context).maybePop();
      },
      direction: DismissiblePageDismissDirection.vertical,
      isFullScreen: true,
      child: Hero(
        tag: widget.asset.id,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AssetThumbnailImage(
              key: ValueKey(
                  'AssetPreview_AssetThumbnailVideo_${widget.asset.id}'),
              id: 'preview',
              fromId: 'grid',
              cubit: widget.cubit,
              asset: widget.asset,
              thumbnailOption: getThumbnailOption(context),
              width: widget.asset.width.toDouble(),
              height: widget.asset.height.toDouble(),
              fit: BoxFit.contain,
              placeholderColor: Colors.black,
            ),
            if (_controller != null)
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              )
          ],
        ),
      ),
    );
  }

  ThumbnailOption getThumbnailOption(BuildContext context) {
    if (widget.cubit.configs.thumbnailOptionPreview != null) {
      return widget.cubit.configs.thumbnailOptionPreview!.call(widget.asset);
    }
    final maxSize = MediaQuery.of(context).size * 2;
    final aspectRatio = widget.asset.width / widget.asset.height;
    final ratio = aspectRatio < 1
        ? maxSize.width / widget.asset.width
        : maxSize.height / widget.asset.height;
    final width = widget.asset.width * ratio;
    final height = widget.asset.height * ratio;

    if (Platform.isAndroid) {
      return ThumbnailOption(
        size: ThumbnailSize(width.toInt(), height.toInt()),
      );
    }
    return ThumbnailOption.ios(
      size: ThumbnailSize(width.toInt(), height.toInt()),
      deliveryMode: DeliveryMode.highQualityFormat,
    );
  }
}
