import 'package:dr_nashar_admin/firebase/web/fireweb.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';



class NewsScreen extends StatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
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
    body: SafeArea(
      child: Stack(
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: FireWeb.newsData.length,
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                      constraints: BoxConstraints(maxWidth: 600),
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
                        child: Stack(
                          children: [
                            Shimmer.fromColors(
                              child: Container(
                                height: 200,
                                color: Colors.black,
                                width: double.maxFinite,
                              ),
                              highlightColor: Colors.black54,
                              baseColor: Colors.black,
                            ),
                             Image.network(FireWeb.newsData.values.elementAt(index)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),
                                  Container(
                                      decoration: BoxDecoration(color:Colors.white,borderRadius: BorderRadius.circular(50)),
                                      child: IconButton(onPressed: (){
                                        setState(() {
                                          isLoading=true;
                                        });
                                        FireWeb.delete_news(index);
                                        FireWeb.delete_news(index);
                                        setState(() {
                                          isLoading=false;
                                        });
                                        setState(() {
                                          FireWeb.newsData.remove(FireWeb.newsData.keys.elementAt(index));
                                        });
                                      }, icon: Icon(Icons.delete_rounded,size: 20,),color: Colors.red,)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, 'AddNewsScreen');
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
                          'Add Image',
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
        ],
      ),
    ),
    );
  }
}
