import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/firebase/app/yearsdata.dart';
import 'package:flutter/material.dart';

import '../../firebase/app/fireapp.dart';
import '../../firebase/web/fireweb.dart';

class AppLectureScreen extends StatefulWidget {
  const AppLectureScreen({Key? key}) : super(key: key);

  @override
  State<AppLectureScreen> createState() => _AppLectureScreenState();
}

class _AppLectureScreenState extends State<AppLectureScreen> {
  @override
  List <bool> isFavoret = [true,];
  bool isLoading=false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Image(
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
      body: Stack(
          children: [SafeArea(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ListView.builder(
                        itemCount: YearsData.subjectData.length,
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
                                              '${YearsData.subjectData[index]['name']}',
                                              maxLines: 3,
                                              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                            )),
                                        Row(
                                          children: [

                                            IconButton(
                                              onPressed: () async{
                                                setState(() {
                                                  isLoading=true;

                                                });

                                                await FirebaseFirestore.instance.collection('${YearsData.selectedYear}-lectures').doc('${YearsData.selectedSubject}').collection('videos').doc(YearsData.subjectData[index].id).delete();


                                                setState(() {
                                                  isLoading=false;
                                                  Navigator.pop(context);
                                                });
                                              },
                                              icon: Icon(
                                                Icons.delete_rounded,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ],
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
                      Navigator.pushNamed(context, 'AppAddLectureScreen');
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
                            'Add Lectuer',
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
    );
  }
}
