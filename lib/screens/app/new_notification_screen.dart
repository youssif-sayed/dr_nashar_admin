import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar_admin/firebase/app/fireapp.dart';
import 'package:dr_nashar_admin/utils/helpers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../utils/constants.dart';

class NewNotificationScreen extends StatefulWidget {
  static const routeName = '/new-notification';

  const NewNotificationScreen({super.key});

  @override
  State<NewNotificationScreen> createState() => _NewNotificationScreenState();
}

class _NewNotificationScreenState extends State<NewNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _pickedImage;
  String? _notificationTitle;
  String? _notificationBody;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
        actions: [
          IconButton(onPressed: ()async{
            await FireApp.get_notifiaction();
            Navigator.of(context).pushNamed('NotificationManageScreen');
          }, icon: Icon(Icons.menu))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'New Notification',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Builder(builder: (context) {
                      if (_pickedImage != null) {
                        return Image.file(
                          File(_pickedImage!.path),
                          fit: BoxFit.contain,
                        );
                      }
                      return Center(
                        child: Text(
                          'Tap to choose an image (Optional)',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 18,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Notification Title',
                    hintText: 'Notification title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _notificationTitle = newValue,
                ),
                const SizedBox(height: 24),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Notification Body',
                    hintText: 'Notification body',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a body';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _notificationBody = newValue,
                ),
                const SizedBox(height: 24),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Material(
                    color: Colors.blueAccent,
                    child: InkWell(
                      onTap: _isLoading ? () {} : _sendNotification,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Send',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );

    if (pickedImage == null) return;

    setState(() {
      _pickedImage = pickedImage;
    });
  }

  Future<void> _sendNotification() async {
    try {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        FocusScope.of(context).unfocus();

        setState(() => _isLoading = true);

        String? imageUrl;

        if (_pickedImage != null) {
          final ref = FirebaseStorage.instance.ref(_notificationImageRef);
          await ref.putFile(File(_pickedImage!.path));
          imageUrl = await ref.getDownloadURL();
        }

        log('imageUrl: $imageUrl');

        await Helpers.sendFcmNotification(
          to: Constants.fcmAllTopic,
          title: _notificationTitle!,
          body: _notificationBody!,
          imageUrl: imageUrl,
        );

        await FirebaseFirestore.instance.collection('notifications').add({
          'title': _notificationTitle,
          'body': _notificationBody,
          'imageUrl': imageUrl,
          'createdAt': Timestamp.now(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Notification sent successfully'),
          ),
        );

        setState(() {
          _pickedImage = null;
          _notificationTitle = null;
          _notificationBody = null;
        });

        _formKey.currentState!.reset();
      }
    } catch (error) {
      log(error.toString());

      FirebaseStorage.instance.ref('_notificationImageRef').delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Something went wrong'),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String get _notificationImageRef {
    return '/notifications_images/notification_${Timestamp.now().millisecondsSinceEpoch}${path.extension(_pickedImage!.path)}';
  }
}
