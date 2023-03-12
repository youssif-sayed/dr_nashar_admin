
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

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
        shadowColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: (){
                Navigator.pushNamed(context, 'WebSiteScreen');
              },
              child: Container(

                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Colors.purpleAccent,Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Icon(Icons.web_rounded,color: Colors.white,size: 100,),
                    Text('Web Site',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5,),
            MaterialButton(
              onPressed: (){
                Navigator.of(context).pushNamed('AppScreen');
              },
              child: Container(

                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Colors.green, Colors.blueAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    Icon(Icons.phone_iphone_rounded,color: Colors.white,size: 100,),
                    Text('Mobile App',style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


