import 'package:flutter/material.dart';
import 'package:it_requires_app/Utils/Images/ImageUtil.dart';

class ImageCustomWidget extends StatefulWidget {
  final TextEditingController imageController1;
  final TextEditingController imageController2;
  final bool isLocked;

  const ImageCustomWidget({
    super.key,
    required this.imageController1,
    required this.imageController2,
    required this.isLocked,
  });

  @override
  State<ImageCustomWidget> createState() => _ImageState();
}

class _ImageState extends State<ImageCustomWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 20, 15),
        child: SizedBox(
          height: 150,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: _loadPhoto(widget.imageController1),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: _loadPhoto(widget.imageController2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _loadPhoto(TextEditingController controller) {
    return controller.text.isEmpty
        ? IconButton(
            splashColor: widget.isLocked ? Colors.transparent : null,
            highlightColor: widget.isLocked ? Colors.transparent : null,
            enableFeedback: false,
            iconSize: 65,
            icon: const Icon(Icons.photo_filter),
            onPressed: () {
              if (!widget.isLocked) {
                _changePhotoDialog(controller);
              }
            },
          )
        : buildImageIconButton(controller);
  }

  buildImageIconButton(TextEditingController controller) {
    return Stack(
      fit: StackFit.expand,
      children: [
        IconButton(
          splashColor: widget.isLocked ? Colors.transparent : null,
          highlightColor: widget.isLocked ? Colors.transparent : null,
          enableFeedback: false,
          icon: Ink.image(
              height: 250,
              width: 250,
              image: ImageUtil.provideImageFromPath(controller.text)),
          onPressed: () {
            if (!widget.isLocked) {
              _changePhotoDialog(controller);
            }
          },
        ),
        Visibility(
          visible: !widget.isLocked,
          child: Positioned(
            right: MediaQuery.of(context).devicePixelRatio /
                MediaQuery.of(context).size.width,
            child: IconButton(
              enableFeedback: false,
              iconSize: 30,
              color: Colors.red,
              icon: const Icon(Icons.highlight_remove_outlined),
              splashColor: Colors.transparent,
              onPressed: () {
                removeImage(controller);
              },
            ),
          ),
        ),
      ],
    );
  }

  _changePhotoDialog(TextEditingController controller) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          contentPadding: const EdgeInsets.only(top: 10.0),
          content: SizedBox(
            width: 800.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: const [
                    Text(
                      "Selecionar foto",
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  color: Colors.grey,
                  height: 5,
                  thickness: 1,
                ),
                SizedBox(
                  height: 110,
                  child: Center(
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                const Text(
                                  "Galeria",
                                  style: TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  splashColor: Colors.transparent,
                                  enableFeedback: false,
                                  iconSize: 50,
                                  icon: const Icon(Icons.image_rounded),
                                  onPressed: () async {
                                    String? imageEncodedInB64 = await ImageUtil
                                        .accessGalleryAndReturnB64Image();

                                    if (imageEncodedInB64 == null) {
                                      return;
                                    }
                                    setState(() {
                                      controller.text = imageEncodedInB64;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Column(
                              children: [
                                const Text(
                                  "Câmera",
                                  style: TextStyle(fontSize: 18),
                                ),
                                IconButton(
                                  splashColor: Colors.transparent,
                                  enableFeedback: false,
                                  iconSize: 50,
                                  icon: const Icon(Icons.camera_alt),
                                  onPressed: () async {
                                    String? imageEncodedInB64 = await ImageUtil
                                        .accessCameraAndReturnB64Image();

                                    if (imageEncodedInB64 == null) {
                                      return;
                                    }
                                    setState(() {
                                      controller.text = imageEncodedInB64;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  removeImage(TextEditingController controller) {
    setState(() {
      controller.text = "";
    });
  }
}
