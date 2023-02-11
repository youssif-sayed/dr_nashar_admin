import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../firebase/web/fireweb.dart';

class LectuerScreen extends StatelessWidget {
  @override
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
      body: SafeArea(
          child: ListView.builder(
              itemCount: FireWeb.years?.length,
              itemBuilder: (BuildContext context, int index) {
                return listItem(index,context);
              })),
    );
  }

  Widget? listItem(int index, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${FireWeb.removeUnderScore(FireWeb.years?.elementAt(index))}',
            style: TextStyle(fontSize: 20, color: Colors.teal,fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0;
                        i < FireWeb.yearsData?.values.elementAt(index).length;
                        i++)
                      termViewer(i, index,context),
                  ],
                ),
              )),
          SizedBox(
            height: 5,
          ),
          Divider(
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  Widget termViewer(int index1, int index, BuildContext context) {
    //print(FireWeb.yearsData?.values.elementAt(index).keys.elementAt(index1));
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          //decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.teal),
          //borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${FireWeb.removeUnderScore(FireWeb.yearsData?.values.elementAt(index).keys.elementAt(index1))}',
                style: TextStyle(fontSize: 20, color: Colors.blueGrey),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0;
                        i <
                            FireWeb.yearsData?.values
                                .elementAt(index)
                                .values
                                .elementAt(index1)
                                .length;
                        i++)
                      subjectViewer(index, index1, i,context),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget subjectViewer(int index, int index1, int index2, BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            FireWeb.currentSubject = FireWeb.yearsData?.values.elementAt(index).values.elementAt(index1).values.elementAt(index2);
            FireWeb.inhetanceSubjectNumbers=[index,index1,index2];
            Navigator.pushNamed(context, 'SubjectScreen');
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${FireWeb.removeUnderScore(FireWeb.yearsData?.values.elementAt(index).values.elementAt(index1).keys.elementAt(index2))}',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    softWrap: false,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded),
              ],
            ),
          ),
        ),
        SizedBox(height: 10,)
      ],
    );
  }
}
