import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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
  final ImagePicker picker = ImagePicker();
  late XFile? image = XFile('');
  late XFile? photo = XFile('');

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: const Icon(Icons.logo_dev),
        title: Text(widget.title),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.share))],
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 16,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [BoxShadow(blurRadius: 0.5, spreadRadius: 1)],
                  color: Colors.white,
                  image: _decorationImage()),
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
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Tap to change image",
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      decoration: const InputDecoration(
                          label: Text("Tap to enter text")),
                      controller: controller,
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {},
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
                  image = await picker.pickImage(source: ImageSource.gallery);
                  setState(() {});
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
                  photo = await picker.pickImage(source: ImageSource.camera);
                   setState(() {});
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
