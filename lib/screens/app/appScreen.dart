import 'package:flutter/material.dart';
import '../../firebase/app/yearsdata.dart';
import '../../firebase/web/fireweb.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({Key? key}) : super(key: key);

  @override
  State<AppScreen> createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  @override
  bool isLoading=false;

  Widget build(BuildContext context) {
    var hight=MediaQuery.of(context).size.height;
    var width=MediaQuery.of(context).size.width;
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
        child: Stack(
          children: [GridView.count(primary: false,
            childAspectRatio: width/hight*2,
            crossAxisSpacing: 1,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            children: [
              MaterialButton(
                onPressed: ()async{
                  setState(() {
                    isLoading=true;

                  });
                  bool isyears = await YearsData.get_years_data();

                  setState(() {
                    isLoading=false;
                  });
                  if (isyears)
                  Navigator.pushNamed(context, 'AppSubjectScreen');
                },
                child: Container(


                  width: MediaQuery.of(context).size.width ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.blueAccent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 5,),
                      Icon(Icons.school_rounded,color: Colors.white,size: 50,),
                      Text('Lectuers',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),
              MaterialButton(
                onPressed: ()async{
                  setState(() {
                    isLoading=true;

                  });

                  setState(() {
                    isLoading=false;
                  });
                  Navigator.pushNamed(context, 'AttendanceScreen');
                },
                child: Container(


                  width: MediaQuery.of(context).size.width ,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.green,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 5,),
                      Icon(Icons.qr_code_scanner_rounded,color: Colors.white,size: 50,),
                      Text('Attendance',style: TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold),),
                    ],
                  ),
                ),
              ),


            ],
          ),
            isLoading?Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Color(0x80000000),
              child: Center(child: CircularProgressIndicator(),),
            ):Container(),
          ],
        ),
      ),
    );
  }
}
