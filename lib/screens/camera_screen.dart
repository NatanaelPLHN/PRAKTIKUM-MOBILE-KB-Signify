import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';

late List<CameraDescription> cameras;

class MyCameraScreen extends StatefulWidget {
  final FlutterVision vision;
  const MyCameraScreen({super.key, required this.vision});

  @override
  State<MyCameraScreen> createState() => _MyCameraScreenState();
}

class _MyCameraScreenState extends State<MyCameraScreen> {
  late CameraController controller = CameraController(cameras[0], ResolutionPreset.veryHigh);
  late List<Map<String, dynamic>> yoloResults;
  CameraImage? cameraImage;
  FlashMode flashMode = FlashMode.off;
  bool isLoaded = false;
  bool isDetecting = false;
  int _currentSlide = 0;
  CarouselSliderController carouselController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    cameras = await availableCameras();
    // controller = CameraController(cameras[0], ResolutionPreset.veryHigh);
    controller.initialize().then((value) {
      loadYoloModel().then((value) {
        setState(() {
          isLoaded = true;
          isDetecting = false;
          yoloResults = [];
        });
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized && !isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Language Detector'),
        backgroundColor: const Color.fromRGBO(233, 30, 99, 1),
        actions: [
          IconButton(
            icon: Icon(
              flashMode == FlashMode.torch ? Icons.flash_off : Icons.flash_on,
            ),
            onPressed: () async {
              // Toggle flash mode
              if (flashMode == FlashMode.torch) {
                await controller.setFlashMode(FlashMode.off);
                setState(() {
                  flashMode = FlashMode.off;
                });
              } else {
                await controller.setFlashMode(FlashMode.torch);
                setState(() {
                  flashMode = FlashMode.torch;
                });
              }
            },
          ),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 19, 19, 19),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Camera preview
          AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: CameraPreview(controller),
          ),
          // Detection overlay
          ...displayBoxesAroundRecognizedObjects(screenSize),
          Positioned(
              bottom: 0,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                ),
                width: 80,
                child: Column(
                  children: [
                    CarouselSlider(
                      carouselController: carouselController,
                      options: CarouselOptions(
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentSlide = index; // Update the active slide
                          });
                        },
                        height: 20,
                        viewportFraction: 0.2,
                        enlargeCenterPage: true,
                        enableInfiniteScroll: false,
                      ),
                      items: ['Scan', 'Photo'].asMap().entries.map((entry) {
                        int index = entry.key; // Index of the current item
                        String label = entry.value; // Value of the current item
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentSlide = index;
                            });
                            carouselController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.symmetric(horizontal: 5.0), // Add spacing
                                child: Center(
                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: _currentSlide == index ? Colors.amber : Colors.white,
                                      fontWeight: _currentSlide == index ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(), // Convert to list
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/scan');
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.photo_library,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        _currentSlide == 1
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 5,
                                    color: Colors.white,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () async {
                                    if (controller.value.isInitialized) {
                                      try {
                                        // Check and request storage permissions
                                        final image = await controller.takePicture();

                                        final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
                                        final File savedImage = File('${Directory.systemTemp.path}/$fileName');
                                        await savedImage.writeAsBytes(await image.readAsBytes());
                                        await Gal.putImage(savedImage.path);

                                        debugPrint("Photo saved to: ${savedImage.path}");
                                      } catch (e) {
                                        debugPrint('Error taking photo: $e');
                                      }
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.circle,
                                    color: Colors.white,
                                  ),
                                  iconSize: 50,
                                ),
                              )
                            : isDetecting
                                ? Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 5, color: Colors.white, style: BorderStyle.solid),
                                    ),
                                    child: IconButton(
                                      onPressed: () async {
                                        stopDetection();
                                      },
                                      icon: const Icon(
                                        Icons.stop,
                                        color: Colors.red,
                                      ),
                                      iconSize: 50,
                                    ))
                                : Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 5, color: Colors.white, style: BorderStyle.solid),
                                    ),
                                    child: IconButton(
                                      onPressed: () async {
                                        await startDetection();
                                      },
                                      icon: const Icon(
                                        Icons.play_arrow,
                                        color: Colors.white,
                                      ),
                                      iconSize: 50,
                                    ),
                                  ),
                        IconButton(
                          iconSize: 35,
                          icon: const Icon(Icons.cameraswitch_rounded),
                          color: Colors.white,
                          onPressed: () {
                            // Switch between front and back cameras
                            final isFrontCamera = controller.description.lensDirection == CameraLensDirection.front;
                            final newCamera = isFrontCamera ? cameras.first : cameras.last;
                            switchCamera(newCamera);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(
      labels: 'assets/labels.txt',
      modelPath: 'assets/yolov8n.tflite',
      modelVersion: "yolov8",
      numThreads: 2,
      useGpu: true,
    );
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> yoloOnFrame(CameraImage cameraImage) async {
    final result = await widget.vision.yoloOnFrame(
      bytesList: cameraImage.planes.map((plane) => plane.bytes).toList(),
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      iouThreshold: 0.4,
      confThreshold: 0.1,
      classThreshold: 0.5,
    );
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  Future<void> startDetection() async {
    setState(() {
      isDetecting = true;
    });
    if (controller.value.isStreamingImages) {
      return;
    }
    await controller.startImageStream((image) {
      if (!isDetecting) return;
      cameraImage = image;
      yoloOnFrame(image);
    });
  }

  Future<void> stopDetection() async {
    // await controller.stopImageStream();
    setState(() {
      isDetecting = false;
      yoloResults.clear();
    });
  }

  Future<void> switchCamera(CameraDescription newCamera) async {
    await controller.dispose();
    controller = CameraController(newCamera, ResolutionPreset.medium);
    await controller.initialize();
    setState(() {});
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (cameraImage == null || yoloResults.isEmpty) return [];
    double factorX = screen.width / cameraImage!.height;
    double factorY = screen.height / cameraImage!.width;

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);

    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}

class ScanImage extends StatefulWidget {
  final FlutterVision vision;
  const ScanImage({super.key, required this.vision});

  @override
  State<ScanImage> createState() => _ScanImageState();
}

class _ScanImageState extends State<ScanImage> {
  late List<Map<String, dynamic>> yoloResults;
  File? imageFile;
  int imageHeight = 1;
  int imageWidth = 1;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    loadYoloModel().then((value) {
      setState(() {
        yoloResults = [];
        isLoaded = true;
      });
    });
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (!isLoaded) {
      return const Scaffold(
        body: Center(
          child: Text("Model not loaded, waiting for it"),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Language Detector'),
        backgroundColor: const Color.fromRGBO(233, 30, 99, 1),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          imageFile != null ? Image.file(imageFile!) : const SizedBox(),
          Container(
            alignment: Alignment.bottomCenter,
            margin: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: pickImage,
                  child: const Text("Pick an image"),
                ),
                ElevatedButton(
                  onPressed: yoloOnImage,
                  child: const Text("Detect"),
                )
              ],
            ),
          ),
          ...displayBoxesAroundRecognizedObjects(size),
        ],
      ),
    );
  }

  Future<void> loadYoloModel() async {
    await widget.vision.loadYoloModel(labels: 'assets/labels.txt', modelPath: 'assets/yolov8n.tflite', modelVersion: "yolov8", quantization: false, numThreads: 2, useGpu: true);
    setState(() {
      isLoaded = true;
    });
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    // Capture a photo
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      setState(() {
        imageFile = File(photo.path);
      });
    }
  }

  yoloOnImage() async {
    yoloResults.clear();
    Uint8List byte = await imageFile!.readAsBytes();
    final image = await decodeImageFromList(byte);
    imageHeight = image.height;
    imageWidth = image.width;
    final result = await widget.vision.yoloOnImage(bytesList: byte, imageHeight: image.height, imageWidth: image.width, iouThreshold: 0.8, confThreshold: 0.4, classThreshold: 0.5);
    if (result.isNotEmpty) {
      setState(() {
        yoloResults = result;
      });
    }
  }

  List<Widget> displayBoxesAroundRecognizedObjects(Size screen) {
    if (yoloResults.isEmpty) return [];

    double factorX = screen.width / (imageWidth);
    double imgRatio = imageWidth / imageHeight;
    double newWidth = imageWidth * factorX;
    double newHeight = newWidth / imgRatio;
    double factorY = newHeight / (imageHeight);

    double pady = (screen.height - newHeight) / 2;

    Color colorPick = const Color.fromARGB(255, 50, 233, 30);
    return yoloResults.map((result) {
      return Positioned(
        left: result["box"][0] * factorX,
        top: result["box"][1] * factorY + pady,
        width: (result["box"][2] - result["box"][0]) * factorX,
        height: (result["box"][3] - result["box"][1]) * factorY,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Colors.pink, width: 2.0),
          ),
          child: Text(
            "${result['tag']} ${(result['box'][4] * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              background: Paint()..color = colorPick,
              color: Colors.white,
              fontSize: 18.0,
            ),
          ),
        ),
      );
    }).toList();
  }
}
