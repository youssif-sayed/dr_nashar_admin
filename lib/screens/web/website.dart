import 'package:flutter/material.dart';
import '../../firebase/web/fireweb.dart';

class WebSiteScreen extends StatefulWidget {
  const WebSiteScreen({Key? key}) : super(key: key);

  @override
  State<WebSiteScreen> createState() => _WebSiteScreenState();
}

class _WebSiteScreenState extends State<WebSiteScreen> {
  @override
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var hight = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: const Image(
            image: AssetImage(
              'images/Icons/appIcon.png',
            ),
            height: 50,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            GridView.count(
              primary: false,
              childAspectRatio: width / hight * 2,
              crossAxisSpacing: 1,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: [
                MaterialButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await FireWeb.getYears();
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushNamed(context, 'LectuerScreen');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blueAccent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Icon(
                          Icons.school_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                        Text(
                          'Lectuers',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await FireWeb.getME();
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushNamed(context, 'MathAndEnglishScreen');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.redAccent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Icon(
                          Icons.co_present_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                        Text(
                          'Math & English',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });

                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushNamed(context, 'TopStudentsScreen');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.green,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Icon(
                          Icons.hotel_class_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                        Text(
                          'Top Students',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await FireWeb.get_images();

                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushNamed(context, 'ImagesScreen');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.orangeAccent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Icon(
                          Icons.photo_library_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                        Text(
                          'Images',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await FireWeb.get_news();

                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushNamed(context, 'NewsScreen');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.cyan,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Icon(
                          Icons.newspaper_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                        Text(
                          'News',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
          ],
        ),
      ),
    );
  }
}
