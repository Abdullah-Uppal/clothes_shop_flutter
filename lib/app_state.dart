import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/cloth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/cloth.dart';

class AppState extends ChangeNotifier {
  AppState() {
    print("AppState constructor");
    FirebaseAuth.instance.userChanges().listen((user) {
      print("Started listening");
      if (user == null) {
        _clothesSubscription?.cancel();
        _clothes = [];
        notifyListeners();
        return;
      }
      init();
    });
  }
  StreamSubscription<QuerySnapshot>? _clothesSubscription;
  List<Cloth> _clothes = [];
  List<Cloth> get clothes => _clothes;
  Map<String, Image> images = {};
  void init() {
    _clothesSubscription = FirebaseFirestore.instance
        .collection('clothes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) async {
      _clothes = snapshot.docs.map((doc) {
        var data = doc.data();
        data["_id"] = doc.id;
        final cloth =  Cloth.fromMap(data);
        return cloth;
      }).toList();
      print("Length: " + _clothes.length.toString());
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _clothesSubscription?.cancel();
    super.dispose();
  }
  Future<void> deleteCloth(String id) async {
    final collectionRef = FirebaseFirestore.instance.collection('clothes');
    await collectionRef.doc(id).delete();
    notifyListeners();
  }

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
        if (imageUploadTasks
            .any((task) => task.snapshot.state != TaskState.success)) {
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
