import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/components.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool showCaptureIndicator = false;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: ((context) => const QRScanner()),
                ),
              );
            },
            child: const Icon(Icons.qr_code_scanner_outlined),
          ),
          body: const Center(
            child: Text('Scan for attendance'),
          )),
    );
  }
}

class QRScanner extends StatefulWidget {
  const QRScanner({Key? key}) : super(key: key);

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final List<String> _attendants = [];

  bool showCaptureIndicator = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            MobileScanner(
              controller: MobileScannerController(
                detectionSpeed: DetectionSpeed.noDuplicates,
                facing: CameraFacing.back,
              ),
              onDetect: _onQRCodeDetected,
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.7),
                BlendMode.srcOut,
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        backgroundBlendMode: BlendMode.dstOut),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: showCaptureIndicator
                            ? Border.all(color: Colors.blue, width: 3)
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                  border: showCaptureIndicator
                      ? Border.all(color: Colors.blue, width: 3)
                      : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRCodeDetected(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      debugPrint('Barcode found! ${barcode.rawValue}');
    }

    if (_attendants.contains(barcodes.first.rawValue)) {
      showToast(
        'Student has already been registered',
        ToastGravity.TOP,
      );
      return;
    }

    setState(() {
      showCaptureIndicator = true;
      _attendants.add(barcodes.first.rawValue ?? '');
    });

    await FirebaseFirestore.instance.collection('attendence').add(
      {'student_uid': barcodes.first.rawValue, 'time': DateTime.now()},
    );

    setState(() => showCaptureIndicator = false);
  }
}
