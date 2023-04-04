import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../constants/appBar.dart';
import '../../firebase/web/fireweb.dart';

class ImagesScreen extends StatefulWidget {
  const ImagesScreen({Key? key}) : super(key: key);

  @override
  State<ImagesScreen> createState() => _ImagesScreenState();
}

class _ImagesScreenState extends State<ImagesScreen> {
  @override
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Stack(children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: FireWeb.imagesData?.keys.length,
                      itemBuilder: (BuildContext context, int index) {
                        get_image(index);
                        return Column(
                          children: [
                            Card(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Image.network(FireWeb.imagesUrl![index]),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        '${FireWeb.imagesData?.keys.elementAt(index)}',
                                        maxLines: 3,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      )),
                                      IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await FireWeb.delete_image(index);
                                          await FireWeb.get_images();
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Navigator.pushReplacementNamed(
                                              context, 'ImagesScreen');
                                        },
                                        icon: const Icon(
                                          Icons.delete_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      }),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'AddImageScreen');
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_rounded,
                          size: 30,
                        ),
                        Text(
                          'Add Image',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: const Color(0x80000000),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(),
        ]),
      ),
    );
  }

  Future<void> get_image(int index) async {
    final storageRef = FirebaseStorage.instance.ref();
    final url = await storageRef
        .child("${FireWeb.imagesData.values.elementAt(index)}")
        .getDownloadURL();
  }
}
