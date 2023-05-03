import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cloth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppState extends ChangeNotifier {
  Future<bool> createCloth(Cloth cloth, List<XFile> pickedImages) async {
    bool success = true;
    final collectionRef = FirebaseFirestore.instance.collection('clothes');
    final storageRef = FirebaseStorage.instance.ref();
    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final documentRef = collectionRef.doc();
        List<String> imageUrls = pickedImages
            .map((image) => 'images/${documentRef.id}/${image.name}')
            .toList();
        cloth.images = imageUrls;
        transaction.set(documentRef, cloth.toMap());

        final imageUploadTasks = pickedImages
            .map((image) => storageRef
                .child('images/${documentRef.id}/${image.name}')
                .putFile(File(image.path)))
            .toList();
        
        await Future.wait(imageUploadTasks);
        if (imageUploadTasks.any((task) => task.snapshot.state != TaskState.success)) {
          throw Exception('Failed to upload images');
        } 
      });
      notifyListeners();
    } catch (error) {
      success = false;
    }

    return success;
  }
}
