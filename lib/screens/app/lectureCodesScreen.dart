import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/firebase/app/fireapp.dart';
import 'package:dr_nashar_admin/firebase/app/yearsdata.dart';
import 'package:flutter/material.dart';




class AppLectureCodeScreen extends StatefulWidget {
  const AppLectureCodeScreen({Key? key}) : super(key: key);

  @override
  State<AppLectureCodeScreen> createState() => _AppLectureCodeScreenState();
}

class _AppLectureCodeScreenState extends State<AppLectureCodeScreen> {
  String codesnumbers='';
  String codesExpiretimes='';
  String price='';
  String searchText='';
  bool isFound=false;
  var foundCodes ;
  @override
  void initState() {
     foundCodes= YearsData.lectureCodes;
    super.initState();
  }

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
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
                child: TextField(
                  onChanged: (value) {
                    if (value=='')
                      {
                        setState(() {
                          foundCodes=YearsData.lectureCodes;
                        });
                      }
                    else{
                      searchText=value;
                    }
                  },
                  decoration:  InputDecoration(
                      labelText: 'Search', suffixIcon:   IconButton(onPressed: (){
                        isFound =foundCodes.containsKey(searchText);
                        if(isFound){
                          setState(() {
                            foundCodes= {searchText:foundCodes[searchText]};
                          });


                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("code not found")));
                        }
                  },icon: Icon(Icons.search)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.blueAccent)
                  )),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: foundCodes.keys.length,
                    itemBuilder: (contect,index){
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(foundCodes.keys.elementAt(index),style: TextStyle(fontSize: 20),),
                          Row(
                            children: [
                              Text(
                                foundCodes.values.elementAt(index)['used']?'used':'not used',
                              style: TextStyle(fontSize: 20,color:foundCodes.values.elementAt(index)['used']? Colors.red:Colors.green),
                              ),
                              IconButton(onPressed: () async {
                                await FirebaseFirestore.instance.collection('codes').doc('general').update({'${foundCodes.keys.elementAt(index)}':FieldValue.delete()});
                                setState(() {
                                  var deletedCode=foundCodes.keys.elementAt(index);
                                  YearsData.lectureCodes.remove('${deletedCode}');
                                  foundCodes.remove('${deletedCode}');
                                });
                                }, icon: Icon(Icons.delete_rounded,color: Colors.red,)),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                }),
              ),
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(context: context,isScrollControlled: true,shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ), builder: (context){
                    return Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom,),
                      child: Container(
                        height: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 34,),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'number of codes',
                                      hintText: 'Enter Number of codes',
                                    ),
                                    onChanged: (value){codesnumbers=value;},),
                                  SizedBox(height: 34,),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Expire Days',
                                      hintText: 'Enter Expire Days',
                                    ),
                                    onChanged: (value){codesExpiretimes=value;},),
                                  SizedBox(height: 34,),
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Price',
                                      hintText: 'Enter price',
                                    ),
                                    onChanged: (value){price=value;},),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                MaterialButton(onPressed: () async {
                                  if (codesExpiretimes!=''&&codesnumbers!=''&&price!=''){
                                     FireApp.generate_lecture_code(int.parse(codesnumbers),int.parse(codesExpiretimes),price);

                                  }
                                }
                                  ,child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(color: Colors.blueAccent,borderRadius: BorderRadius.circular(50)),
                                    height: 50,
                                    child: Center(child: Text('Enter',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),),
                                  ),),
                                SizedBox(height: 32,),
                              ],
                            ),

                          ],
                        ),
                      ),
                    );
                  });
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
                        'Add Codes',
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
    );
  }
}
