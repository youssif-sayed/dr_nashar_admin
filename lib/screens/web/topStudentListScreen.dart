import 'package:dr_nashar_admin/constants/appBar.dart';
import 'package:flutter/material.dart';

import '../../firebase/web/fireweb.dart';

class TopStudentListScreen extends StatefulWidget {
  const TopStudentListScreen({Key? key}) : super(key: key);

  @override
  State<TopStudentListScreen> createState() => _TopStudentListScreenState();
}

class _TopStudentListScreenState extends State<TopStudentListScreen> {
  @override
  bool isLoading=false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: Stack(
          children: [Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: FireWeb.topStudentData?.keys.length,
                      itemBuilder: (BuildContext context, int index) {

                        return Column(
                          children: [
                            Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                            '${FireWeb.topStudentData?.values.elementAt(index)['name']}',
                                            maxLines: 3,
                                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                          )),
                                      IconButton(
                                        onPressed: () async{
                                          setState(() {
                                            isLoading=true;
                                          });
                                          await FireWeb.delete_topStudent(index);
                                          await FireWeb.getTopStudent();
                                          setState(() {
                                             isLoading=false;
                                          });

                                        },
                                        icon: Icon(
                                          Icons.delete_rounded,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        );
                      }),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'AddTopStudentScreen');
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 30,
                        ),
                        Text(
                          'Add Student',
                          style: TextStyle(fontSize: 30),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
            isLoading?Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0x80000000),
              child: Center(child: CircularProgressIndicator(),),
            ):Container(),
          ]
        ),
      ),
    );
  }
}
