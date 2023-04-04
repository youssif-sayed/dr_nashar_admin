import 'package:dr_nashar_admin/screens/app/new_notification_screen.dart';
import 'package:flutter/material.dart';
import '../../firebase/app/yearsdata.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
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
                    bool isyears = await YearsData.get_years_data();

                    setState(() {
                      isLoading = false;
                    });
                    if (isyears) {
                      Navigator.pushNamed(context, 'AppSubjectScreen');
                    }
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

                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushNamed(context, 'AttendanceScreen');
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
                          Icons.groups_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                        Text(
                          'Attendance',
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
                    await YearsData.get_codes();
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pushNamed(context, 'AppLectureCodesScreen');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.amber,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Icon(
                          Icons.qr_code_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                        Text(
                          'Codes',
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

                    await YearsData.getStudentsData().then((value) {
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.pushNamed(context, 'StudentsDataScreen');
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Icon(
                          Icons.person_rounded,
                          color: Colors.white,
                          size: 50,
                        ),
                        Text(
                          'Students',
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
                    Navigator.pushNamed(
                      context,
                      NewNotificationScreen.routeName,
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.deepOrange,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Icon(
                          Icons.notification_add,
                          color: Colors.white,
                          size: 50,
                        ),
                        Text(
                          'New\nNotification',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
