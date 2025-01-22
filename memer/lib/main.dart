import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
//import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Memer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController controller = TextEditingController();
  ScreenshotController screenshotController = ScreenshotController();
  final ImagePicker picker = ImagePicker();
  late XFile? image = XFile('');
  late XFile? photo = XFile('');
  late Uint8List _imageFile;
  BoxFit? fit = BoxFit.fill;

  DecorationImage? _decorationImage() {
    if (image!.path.isNotEmpty) {
      return DecorationImage(
          image: FileImage(File(image!.path)), fit: BoxFit.fill);
    }
    if (photo!.path.isNotEmpty) {
      return DecorationImage(
          image: FileImage(File(photo!.path)), fit: BoxFit.fill);
    }

    return null;
  }

  ImageProvider fileImage() {
    if (image!.path.isNotEmpty) {
      return FileImage(File(image!.path));
    }
    if (photo!.path.isNotEmpty) {
      return FileImage(File(photo!.path));
    }

    return FileImage(File('path'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset:false,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: const Icon(Icons.logo_dev),
        title: Text(widget.title),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.share))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Screenshot(
              controller: screenshotController,
              child: InkWell(
                onTap: (){
                   showModalBottomSheet(
                              context: context,
                              builder: (context) => openImagepicker());
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      boxShadow: const [
                        BoxShadow(blurRadius: 0.5, spreadRadius: 1)
                      ],
                      color: Colors.white,
                      image: DecorationImage(
                        image: fileImage(),
                        fit: fit,
                      )),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => openImagepicker());
                        },
                        child: (image!.path.isNotEmpty || photo!.path.isNotEmpty)
                            ? const SizedBox()
                            : const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  "Tap to change image",
                                  style: TextStyle(
                                      fontSize: 38, fontWeight: FontWeight.bold),
                                ),
                              ),
                      ),
                      const Spacer(),
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.97,
                            height: MediaQuery.of(context).size.height * 0.14,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  stops: [0.1, 0.3, 0.4, 0.8],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.0),
                                    Colors.black.withOpacity(0.1),
                                    Colors.black.withOpacity(0.2),
                                    Colors.black.withOpacity(0.9)
                                  ]),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            //height: MediaQuery.of(context).size.height* 0.4,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextField(
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                textAlign: TextAlign.center,
                                textInputAction: TextInputAction.done,
                                maxLength: 60,
                                maxLines: 3,
                                minLines: 1,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                                decoration: const InputDecoration(
                                    counterText: '',
                                    errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                    //label: Text("Tap to enter text"),
                                    labelStyle: TextStyle(
                                        color: Colors.black, fontSize: 18)),
                                controller: controller,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   height: 12,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () async {
                screenshotController
                    .capture(delay: const Duration(milliseconds: 500))
                    .then((value) async {
                  _imageFile = value!;
                  final tempDir = await getTemporaryDirectory();
                  final file = await File('${tempDir.path}/image.png').create();
                  await file.writeAsBytes(_imageFile);

                  // await Share.fileFromMemory('Share image', 'image.png',
                  //     value, 'image/png',
                  //     text: 'My image .');

                  await Share.shareXFiles(
                    [XFile(file.path, name: "Custom share")],
                  );
                  await Share.shareXFiles([XFile('${file.path}/image.png')],
                      text: 'Share image');
                  setState(() {});
                });
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Share"),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(Icons.share_rounded)
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                "Image fit",
                                style: TextStyle(fontSize: 22),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        fit = BoxFit.cover;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          "Cover",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        fit = BoxFit.fill;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          "Fill",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        fit = BoxFit.contain;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          "Contain",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        fit = BoxFit.fitWidth;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          "Fill width",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () async {
                                      setState(() {
                                        fit = BoxFit.fitHeight;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Row(
                                      children: [
                                        Text(
                                          "Fill height",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ));
              },
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Fit Image"),
                  SizedBox(
                    width: 4,
                  ),
                  Icon(Icons.image)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget openImagepicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        const Text(
          "Select Image",
          style: TextStyle(fontSize: 22),
        ),
        const SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  controller.text = '';
                  image = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {});
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(Icons.image),
                    SizedBox(
                      width: 16,
                    ),
                    Text(
                      "Select image from gallery",
                      style: TextStyle(fontSize: 18),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  controller.text = '';
                  photo = await picker.pickImage(source: ImageSource.camera);
                  setState(() {});
                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: const Row(
                  children: [
                    Icon(Icons.camera),
                    SizedBox(
                      width: 16,
                    ),
                    Text("Take image from camera",
                        style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
