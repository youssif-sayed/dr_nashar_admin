import 'package:dr_nashar_admin/constants/appBar.dart';
import 'package:dr_nashar_admin/firebase/app/yearsdata.dart';
import 'package:dr_nashar_admin/screens/app/studentWorkScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentsDataScreen extends StatefulWidget {
  const StudentsDataScreen({Key? key}) : super(key: key);

  @override
  State<StudentsDataScreen> createState() => _StudentsDataScreenState();
}

class _StudentsDataScreenState extends State<StudentsDataScreen> {
  bool isLoading = false;
  var selectedYear = 'sec1';
  List students = [];

  selectStudentsYear() {
    switch (selectedYear) {
      case 'sec1':
        students = YearsData.studentsData
            .where((element) => element['grade'] == 'first secondary')
            .toList();
        break;

      case 'sec2':
        students = YearsData.studentsData
            .where((element) => element['grade'] == 'second secondary')
            .toList();
        break;

      case 'sec3':
        students = YearsData.studentsData
            .where((element) => element['grade'] == 'third secondary')
            .toList();
        break;

      case 'prep1':
        students = YearsData.studentsData
            .where((element) => element['grade'] == 'first perportry')
            .toList();
        break;

      case 'prep2':
        students = YearsData.studentsData
            .where((element) => element['grade'] == 'second perportry')
            .toList();
        break;

      case 'prep3':
        students = YearsData.studentsData
            .where((element) => element['grade'] == 'third perportry')
            .toList();
        break;
    }
  }

  @override
  void initState() {
    students = YearsData.studentsData;
    selectStudentsYear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.lightBackgroundGray,
      appBar: CustomAppBar(),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10.0),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedYear = 'sec1';
                                selectStudentsYear();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: selectedYear == 'sec1'
                                      ? Colors.black
                                      : null,
                                  borderRadius: BorderRadius.circular(50),
                                  border: selectedYear == 'sec1'
                                      ? null
                                      : Border.all(width: 1)),
                              child: Text(
                                '1st sec',
                                style: TextStyle(
                                    color: selectedYear == 'sec1'
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedYear = 'sec2';
                                selectStudentsYear();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: selectedYear == 'sec2'
                                      ? Colors.black
                                      : null,
                                  borderRadius: BorderRadius.circular(50),
                                  border: selectedYear == 'sec2'
                                      ? null
                                      : Border.all(width: 1)),
                              child: Text(
                                '2nd sec',
                                style: TextStyle(
                                    color: selectedYear == 'sec2'
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedYear = 'sec3';
                                selectStudentsYear();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: selectedYear == 'sec3'
                                      ? Colors.black
                                      : null,
                                  borderRadius: BorderRadius.circular(50),
                                  border: selectedYear == 'sec3'
                                      ? null
                                      : Border.all(width: 1)),
                              child: Text(
                                '3rd sec',
                                style: TextStyle(
                                    color: selectedYear == 'sec3'
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedYear = 'prep1';
                                selectStudentsYear();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: selectedYear == 'prep1'
                                      ? Colors.black
                                      : null,
                                  borderRadius: BorderRadius.circular(50),
                                  border: selectedYear == 'prep1'
                                      ? null
                                      : Border.all(width: 1)),
                              child: Text(
                                '1st prep',
                                style: TextStyle(
                                    color: selectedYear == 'prep1'
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedYear = 'prep2';
                                selectStudentsYear();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: selectedYear == 'prep2'
                                      ? Colors.black
                                      : null,
                                  borderRadius: BorderRadius.circular(50),
                                  border: selectedYear == 'prep2'
                                      ? null
                                      : Border.all(width: 1)),
                              child: Text(
                                '2nd prep',
                                style: TextStyle(
                                    color: selectedYear == 'prep2'
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                selectedYear = 'prep3';
                                selectStudentsYear();
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: selectedYear == 'prep3'
                                      ? Colors.black
                                      : null,
                                  borderRadius: BorderRadius.circular(50),
                                  border: selectedYear == 'prep3'
                                      ? null
                                      : Border.all(width: 1)),
                              child: Text(
                                '3rd prep',
                                style: TextStyle(
                                    color: selectedYear == 'prep3'
                                        ? Colors.white
                                        : Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10.0),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.white,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${students[index]['firstName']} ${students[index]['lastName']}',
                                    style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      YearsData.getUserAssignmentsAndQuizzes(
                                              userID: students[index].id)
                                          .then((value) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return StudentWorkScreen(studentID: students[index].id,);
                                            },
                                          ),
                                        );
                                      });

                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                    icon: const Icon(
                                      Icons.filter_list_outlined,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ],
                              ),
                              Text('Grade: ${students[index]['grade']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    color: Colors.blue,
                                  ),
                                  overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                        'Email: ${students[index]['email']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15.0,
                                        ),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Text(
                                    'Gender: ${students[index]['gender']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                              Text('Number: ${students[index]['phone']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                  'Father Number: ${students[index]['fatherPhone']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                  overflow: TextOverflow.ellipsis),
                              Text(
                                  'Mother Number: ${students[index]['motherPhone']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                  overflow: TextOverflow.ellipsis),
                              Text('School: ${students[index]['school']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                  overflow: TextOverflow.ellipsis),
                              Text('Place: ${students[index]['place']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                  ),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        );
                      },
                      itemCount: students.length,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
