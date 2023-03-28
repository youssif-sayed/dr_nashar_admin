import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/firebase/app/yearsdata.dart';
import 'package:dr_nashar_admin/screens/app/addAssignmentScreen.dart';
import 'package:dr_nashar_admin/screens/app/addQuizScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLectureScreen extends StatefulWidget {
  const AppLectureScreen({Key? key}) : super(key: key);

  @override
  State<AppLectureScreen> createState() => _AppLectureScreenState();
}

class _AppLectureScreenState extends State<AppLectureScreen> {
  @override
  List<bool> isFavoret = [
    true,
  ];
  bool isLoading = false;

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
      body: Stack(children: [
        SafeArea(
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${YearsData.subjectData[index]['name']}',
                                          maxLines: 3,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          // Quiz
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddQuizScreen()));
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.orange,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              child:  Row(
                                                children: [
                                                  Icon(Icons.add, color: CupertinoColors.white,),
                                                  Text(
                                                    'Q',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: CupertinoColors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Assignment
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddAssignmentScreen())).then((value) {
                                                setState(() {

                                                });
                                              });
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: Colors.green,
                                                borderRadius: BorderRadius.circular(10.0),
                                              ),
                                              child:  Row(
                                                children: [
                                                  Icon(Icons.add, color: CupertinoColors.white,),
                                                  Text(
                                                    'A',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                      color: CupertinoColors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Code
                                          IconButton(onPressed: (){
                                            YearsData.lectureLinkNames.add(YearsData.subjectData[index]['name']);
                                            if (YearsData.subjectData[index]['videoName']!=null){
                                            for(int i=0;i<YearsData.subjectData[index]['videoName'].length;i++){
                                              YearsData.lectureLinkVideosName.add(YearsData.subjectData[index]['videoName'][i]);
                                              YearsData.lectureLinkVideosUrls.add(YearsData.subjectData[index]['videos'][i]);
                                            }}
                                            if (YearsData.subjectData[index]['docName']!=null){
                                            for(int i=0;i<YearsData.subjectData[index]['docName'].length;i++){
                                              YearsData.lectureLinkDocsName.add(YearsData.subjectData[index]['docName'][i]);
                                              YearsData.lectureLinkDocsUrls.add(YearsData.subjectData[index]['docs'][i]);
                                            }
                                            }
                                            print(YearsData.lectureLinkNames);
                                            print(YearsData.lectureLinkVideosName);
                                            print(YearsData.lectureLinkVideosUrls);
                                            print(YearsData.lectureLinkDocsName);
                                            print(YearsData.lectureLinkDocsUrls);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content:
                                                Center(child: Text('Lectuer added!')),
                                              ),
                                            );
                                          }, icon: Icon(Icons.add_link),color: Colors.blueAccent,),
                                          IconButton(
                                            onPressed: () async {
                                              setState(() {
                                                isLoading = true;
                                              });

                                              await FirebaseFirestore.instance
                                                  .collection(
                                                  '${YearsData.selectedYear}-lectures')
                                                  .doc(
                                                  '${YearsData.selectedSubject}')
                                                  .collection('videos')
                                                  .doc(YearsData
                                                  .subjectData[index].id)
                                                  .delete();
                                              await FirebaseFirestore.instance
                                                  .collection('codes')
                                                  .doc(YearsData.subjectData[index]
                                              ['id'])
                                                  .delete();

                                              setState(() {
                                                isLoading = false;
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
                  style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child:  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 30,
                        ),
                        Text(
                          'Add Lecture',
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
    );
  }
}