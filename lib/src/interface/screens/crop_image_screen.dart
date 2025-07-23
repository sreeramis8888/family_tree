import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:familytree/src/data/constants/color_constants.dart';
import 'package:flutter/material.dart';
import 'package:custom_image_crop/custom_image_crop.dart';

enum CropShape { circle, rectangle }

class CropImageScreen extends StatefulWidget {
  final File imageFile;
  final CropShape shape;
  final Size? aspectRatio;

  const CropImageScreen({
    super.key,
    required this.imageFile,
    this.shape = CropShape.circle,
    this.aspectRatio,
  });

  @override
  _CropImageScreenState createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  late CustomImageCropController controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _cropImage() async {
    setState(() {
      _isLoading = true;
    });

    final MemoryImage? croppedResult = await controller.onCropImage();

    if (croppedResult != null) {
      Navigator.of(context).pop(croppedResult.bytes);
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Image'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          _isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: kBlack,
                    ),
                  ),
                )
              : IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: _cropImage,
                ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              child: CustomImageCrop(
                backgroundColor: Colors.black,
                cropController: controller,
                image: FileImage(widget.imageFile),
                ratio: widget.aspectRatio != null
                    ? Ratio(
                        width: widget.aspectRatio!.width,
                        height: widget.aspectRatio!.height)
                    : null,
                shape: widget.shape == CropShape.circle
                    ? CustomCropShape.Circle
                    : CustomCropShape.Square,
                borderRadius: 0,
                canRotate: true,
                canMove: true,
                canScale: true,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildControlButton(
                  icon: Icons.refresh,
                  onPressed: () => controller.reset(),
                  tooltip: 'Reset',
                ),
                _buildControlButton(
                  icon: Icons.zoom_in,
                  onPressed: () => controller.addTransition(
                    CropImageData(scale: 1.2),
                  ),
                  tooltip: 'Zoom In',
                ),
                _buildControlButton(
                  icon: Icons.zoom_out,
                  onPressed: () => controller.addTransition(
                    CropImageData(scale: 0.8),
                  ),
                  tooltip: 'Zoom Out',
                ),
                _buildControlButton(
                  icon: Icons.rotate_left,
                  onPressed: () => controller.addTransition(
                    CropImageData(angle: -pi / 2),
                  ),
                  tooltip: 'Rotate Left',
                ),
                _buildControlButton(
                  icon: Icons.rotate_right,
                  onPressed: () => controller.addTransition(
                    CropImageData(angle: pi / 2),
                  ),
                  tooltip: 'Rotate Right',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
