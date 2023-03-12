import 'dart:math';
import 'dart:typed_data';
import 'dart:io';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/firebase/app/yearsdata.dart';


class FireApp{

  static Future<void> generate_lecture_code(int num,int expireTimes)
  async {
    final random = Random();
    List<String> stringCodes=[];
    List<int> codes = List<int>.generate(num, (index) => random.nextInt(999999)+100000);
    Map<String,dynamic> codeMap = {'used':false,'UID':'','expireDate':expireTimes,};
    Map<String,dynamic> newMap={};
    for (int i=0;i<num;i++)
    {
      stringCodes.add('AS-${codes[i]}');
      newMap.addAll({stringCodes[i]:codeMap});
    }
    final docRef = FirebaseFirestore.instance.collection("codes").doc("${YearsData.lectureID}");
    docRef.update(newMap);
    final data =await createInvoice(stringCodes);
    savePdfFile('generated codes', data);
  }
  static Future<Uint8List> createInvoice(list) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.ListView.builder(itemBuilder:(context,index){
            return pw.Text(list[index]);
          }, itemCount: list.length,padding: pw.EdgeInsets.all(18));
        },
      ),
    );
    return pdf.save();
  }



  static Future<void> savePdfFile(String fileName, Uint8List byteList) async {
    final output = await getTemporaryDirectory();
    var filePath = "${output.path}/$fileName.pdf";
    final file = File(filePath);
    await file.writeAsBytes(byteList);
    await OpenDocument.openDocument(filePath: filePath);
  }



}