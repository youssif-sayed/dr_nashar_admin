import 'package:dr_nashar_admin/constants/appBar.dart';
import 'package:flutter/material.dart';

import '../../firebase/web/fireweb.dart';

class TopStudentsScreen extends StatefulWidget {
  const TopStudentsScreen({Key? key}) : super(key: key);

  @override
  State<TopStudentsScreen> createState() => _TopStudentsScreenState();
}

class _TopStudentsScreenState extends State<TopStudentsScreen> {
  @override
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var hight = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Stack(
          children: [
            GridView.count(
              primary: false,
              childAspectRatio: width / hight * 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              children: [
                year_button('prep_1'),
                year_button('prep_2'),
                year_button('prep_3'),
                year_button('sec_1'),
                year_button('sec_2'),
                year_button('sec_3'),
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

  Widget year_button(String year) {
    return MaterialButton(
      onPressed: () async {
        setState(() {
          isLoading = true;
        });
        FireWeb.topStudentYear = year;
        await FireWeb.getTopStudent();
        setState(() {
          isLoading = false;
        });
        Navigator.pushNamed(context, 'TopStudentListScreen');
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.deepPurpleAccent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            const Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 50,
            ),
            Text(
              FireWeb.removeUnderScore(year),
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
