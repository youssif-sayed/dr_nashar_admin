import 'package:flutter/material.dart';

import '../../firebase/web/fireweb.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({Key? key}) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
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
                      itemCount: FireWeb.currentSubject.length,
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
                                    '${FireWeb.currentSubject.values.elementAt(index)['name']}',
                                    maxLines: 3,
                                    style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                  )),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {

                                            if (FireWeb.currentSubject.values.elementAt(index)['favourite']) {
                                              FireWeb.currentSubject.values.elementAt(
                                                  index)['favourite'] = false;
                                              FireWeb.update_favourite(index,false);
                                            }
                                            else
                                              {FireWeb.currentSubject.values.elementAt(index)['favourite']=true;
                                             FireWeb.update_favourite(index,true);}

                                          });
                                        },
                                        icon: Icon(
                                          FireWeb.currentSubject.values.elementAt(index)['favourite']
                                              ? Icons.star_rounded
                                              : Icons.star_border_rounded,
                                          color: Colors.amberAccent,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () async{
                                          setState(() {
                                           isLoading=true;

                                          });
                                          await FireWeb.delete_lecture(index);
                                          await FireWeb.getYears();
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
                    Navigator.pushNamed(context, 'AddLecture');
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
