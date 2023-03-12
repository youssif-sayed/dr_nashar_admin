import 'package:flutter/material.dart';

import '../../firebase/web/fireweb.dart';

class MathAndEnglishScreen extends StatefulWidget {
  const MathAndEnglishScreen({Key? key}) : super(key: key);

  @override
  State<MathAndEnglishScreen> createState() => _MathAndEnglishScreenState();
}

class _MathAndEnglishScreenState extends State<MathAndEnglishScreen> {
  @override
  bool is3rd = true;
  bool isLoading = false;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
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
      body: SafeArea(
        child: Stack(
          children: [Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.only(topRight: Radius.circular(12)),
                          color: is3rd ? Colors.white : Colors.blueAccent,
                        ),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                is3rd = true;
                              });
                            },
                            child: Text(
                              'sec 3',
                              style: TextStyle(fontSize: 30,color: is3rd?Colors.blueAccent:Colors.white,),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.only(topLeft: Radius.circular(12)),
                          color: is3rd ? Colors.blueAccent : Colors.white,
                        ),
                        child: TextButton(
                            onPressed: () {
                              setState(() {
                                is3rd = false;
                              });
                            },
                            child: Text(
                              'sec 2',
                              style: TextStyle(fontSize: 30, color: is3rd?Colors.white:Colors.blueAccent,),
                            )),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: is3rd ?
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: FireWeb.MEData?.values.elementAt(1).keys.length,
                                itemBuilder: (BuildContext context, int index) {

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${FireWeb.removeUnderScore(FireWeb.MEData?.values.elementAt(1).keys.elementAt(index))}',
                                              maxLines: 3,
                                              style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.cyan),
                                            ),
                                            IconButton(onPressed: () async {
                                               setState(() {
                                                 isLoading = true;
                                               });
                                               await FireWeb.delete_ME(index,1);
                                               await FireWeb.getME();
                                               setState(() {
                                                 isLoading = false;
                                               });

                                            }, icon: Icon(Icons.delete_rounded,color: Colors.red,),),
                                          ],
                                        ),
                                        Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                            'English',
                                                            maxLines: 3,
                                                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                                          )),
                                                      Visibility(
                                                        visible: false,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {

                                                              if (FireWeb.MEData?.values.elementAt(1).values.elementAt(index).values.elementAt(0)['favourite']) {

                                                                FireWeb.update_ME_favourite(1,index,0,false);
                                                              }
                                                              else
                                                              {
                                                              FireWeb.update_ME_favourite(1,index,0,true);
                                                              }

                                                            });
                                                          },
                                                          icon: Icon(
                                                            FireWeb.MEData?.values.elementAt(1).values.elementAt(index).values.elementAt(0)['favourite']
                                                                ? Icons.star_rounded
                                                                : Icons.star_border_rounded,
                                                            color: Colors.amberAccent,
                                                          ),
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
                                        Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                            'Math',
                                                            maxLines: 3,
                                                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                                          )),
                                                      Visibility(
                                                        visible: false,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {

                                                              if (FireWeb.MEData?.values.elementAt(1).values.elementAt(index).values.elementAt(1)['favourite']) {

                                                                FireWeb.update_ME_favourite(1,index,1,false);
                                                              }
                                                              else
                                                              {FireWeb.MEData?.values.elementAt(1).values.elementAt(index).values.elementAt(1)['favourite']=true;
                                                                FireWeb.update_ME_favourite(1,index,1,true);
                                                              }

                                                            });
                                                          },
                                                          icon: Icon(
                                                            FireWeb.MEData?.values.elementAt(1).values.elementAt(index).values.elementAt(1)['favourite']
                                                                ? Icons.star_rounded
                                                                : Icons.star_border_rounded,
                                                            color: Colors.amberAccent,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              FireWeb.MEYear=1;
                              Navigator.pushNamed(context, 'AddMELectureScreen');
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
                    ) :
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ListView.builder(
                                itemCount: FireWeb.MEData?.values.elementAt(0).keys.length,
                                itemBuilder: (BuildContext context, int index) {

                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '${FireWeb.removeUnderScore(FireWeb.MEData?.values.elementAt(0).keys.elementAt(index))}',
                                              maxLines: 3,
                                              style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.cyan),
                                            ),
                                            IconButton(onPressed: () async {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              await FireWeb.delete_ME(index,0);
                                              await FireWeb.getME();
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }, icon: Icon(Icons.delete_rounded,color: Colors.red,),),
                                          ],
                                        ),
                                        Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                            'English',
                                                            maxLines: 3,
                                                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                                          )),
                                                      Visibility(
                                                        visible: false,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {

                                                              if (FireWeb.MEData?.values.elementAt(0).values.elementAt(index).values.elementAt(0)['favourite']) {

                                                                FireWeb.update_ME_favourite(0,index,0,false);
                                                              }
                                                              else
                                                              {
                                                                FireWeb.update_ME_favourite(0,index,0,true);
                                                              }

                                                            });
                                                          },
                                                          icon: Icon(
                                                            FireWeb.MEData?.values.elementAt(0).values.elementAt(index).values.elementAt(0)['favourite']
                                                                ? Icons.star_rounded
                                                                : Icons.star_border_rounded,
                                                            color: Colors.amberAccent,
                                                          ),
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
                                        Card(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [

                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: Text(
                                                            'Math',
                                                            maxLines: 3,
                                                            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                                                          )),
                                                      Visibility(
                                                        visible: false,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {

                                                              if (FireWeb.MEData?.values.elementAt(0).values.elementAt(index).values.elementAt(1)['favourite']) {

                                                                FireWeb.update_ME_favourite(0,index,1,false);
                                                              }
                                                              else
                                                              {
                                                              FireWeb.update_ME_favourite(0,index,1,true);
                                                              }

                                                            });
                                                          },
                                                          icon: Icon(
                                                            FireWeb.MEData?.values.elementAt(0).values.elementAt(index).values.elementAt(1)['favourite']
                                                                ? Icons.star_rounded
                                                                : Icons.star_border_rounded,
                                                            color: Colors.amberAccent,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              FireWeb.MEYear=0;
                              Navigator.pushNamed(context, 'AddMELectureScreen');
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
                    ) ,
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
