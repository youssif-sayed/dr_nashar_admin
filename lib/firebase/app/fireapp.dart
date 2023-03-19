import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/firebase/app/yearsdata.dart';
import 'package:path/path.dart';
import 'package:excel/excel.dart';


class FireApp{

  static Future<void> generate_lecture_code(int num,int expireTimes,String price)
  async {
    final random = Random();
    List<String> stringCodes=[];
    List<int> codes = List<int>.generate(num, (index) => random.nextInt(900000)+100000);
    Map<String,dynamic> codeMap = {'used':false,'UID':'','expireDate':expireTimes,'price':price};
    Map<String,dynamic> newMap={};
    for (int i=0;i<num;i++)
    {
      stringCodes.add('AS-${codes[i]}');
      newMap.addAll({stringCodes[i]:codeMap});
    }
    final docRef = FirebaseFirestore.instance.collection("codes").doc("general");
    docRef.update(newMap);
    final data =await createInvoice(stringCodes);
    savePdfFile('generated codes', data!);
  }


  static Future<List<int>?> createInvoice(list) async {
    final pdf = pw.Document();
    var excel = Excel.createExcel();
    Sheet sheetObject = excel[excel.getDefaultSheet()!];
    for(int i =0;i<list.length;i++)
      {
        sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0,rowIndex: i)).value=list[i];
      }
    return excel.save(fileName: 'codes.xlsx');

    // pdf.addPage(
    //   pw.Page(
    //     pageFormat: PdfPageFormat.a4,
    //     build: (pw.Context context) {
    //       return pw.ListView.builder(itemBuilder:(context,index){
    //         return pw.Text(list[index]);
    //       }, itemCount: list.length,padding: pw.EdgeInsets.all(18));
    //     },
    //   ),
    // );
    // return pdf.save();
  }



  static Future<void> savePdfFile(String fileName, List<int> byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.xlsx";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenDocument.openDocument(filePath: filePath);
  }



}