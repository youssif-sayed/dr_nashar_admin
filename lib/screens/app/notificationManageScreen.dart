import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components.dart';
import '../../firebase/app/fireapp.dart';


class NotificationManageScreen extends StatefulWidget {
  const NotificationManageScreen({Key? key}) : super(key: key);

  @override
  State<NotificationManageScreen> createState() => _NotificationManageScreenState();
}

class _NotificationManageScreenState extends State<NotificationManageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    title: const Image(
    image: AssetImage(
      'images/Icons/appIcon.png',
    ),
    height: 50,
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
    shadowColor: Colors.white,

    ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: ListView.builder(
            itemCount: FireApp.notificationData.length,
            itemBuilder: (context,index){
                return Column(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text(FireApp.notificationData[index]['title']),
                        subtitle: Text(FireApp.notificationData[index]['body']),
                        trailing: IconButton(onPressed: ()async{
                          await FirebaseFirestore.instance.collection('notifications').doc(FireApp.notificationData[index].id).delete();
                          showToast(
                            'Deleted!',
                            ToastGravity.TOP,
                          );
                          Navigator.of(context).pop();
                        },icon: Icon(Icons.delete_rounded),color: Colors.red,),
                      ),
                    ),
                    SizedBox(height: 10,)
                  ],
                );
        }),
      ),
    );
  }
}
