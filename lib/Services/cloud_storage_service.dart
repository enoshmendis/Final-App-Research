import 'dart:io';

//packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/cupertino.dart';

const String USER_COLLECTION = "Users";

const String UPLOAD_PRESET = "mhelp_preset";
const String CLOUD_NAME = "detlluopu";

class CloudStorageService extends ChangeNotifier {
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  double progress = 0;

  CloudStorageService() {}

  Future<String?> saveUserImageToStorage(String _uid, PlatformFile _file) async {
    try {
      // Reference _ref =
      //     _storage.ref().child('images/users/$_uid/profile.${_file.extension}');
      // UploadTask _task = _ref.putFile(File(_file.path!));
      // return await _task.then((_result) => _result.ref.getDownloadURL());

      CloudinaryResponse response;
      var cloudinary = CloudinaryPublic(CLOUD_NAME, UPLOAD_PRESET, cache: false);
      response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_file.path!, folder: 'images/users/$_uid', resourceType: CloudinaryResourceType.Auto),
      );

      return response.secureUrl;
    } catch (e) {
      print(e);
    }
  }

  Future<String?> saveChatImageToStorage(String _chatID, String _userID, PlatformFile _file) async {
    try {
      // Reference _ref = _storage.ref().child(
      //     'images/chats/$_chatID/${_userID}_${Timestamp.now().millisecondsSinceEpoch}.${_file.extension}');
      // UploadTask _task = _ref.putFile(File(_file.path!));
      // return await _task.then((_result) => _result.ref.getDownloadURL());

      CloudinaryResponse response;
      var cloudinary = CloudinaryPublic(CLOUD_NAME, UPLOAD_PRESET, cache: false);
      response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_file.path!,
            folder: 'images/chats/$_chatID', resourceType: CloudinaryResourceType.Auto),
      );

      return response.secureUrl;
    } catch (e) {
      print(e);
    }
  }

  Future<String?> savePostMediaToStorage(String _userID, String _path) async {
    try {
      progress = 0;
      notifyListeners();
      CloudinaryResponse response;
      var cloudinary = CloudinaryPublic(CLOUD_NAME, UPLOAD_PRESET, cache: false);
      response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_path, folder: 'posts/$_userID', resourceType: CloudinaryResourceType.Auto),
        onProgress: (count, total) {
          progress = (count / total) * 100;
          print("PROGRESS: " + progress.toString());
          notifyListeners();
        },
      );

      return response.secureUrl;
    } catch (e) {
      print(e);
    }
  }

  Future<String?> uploadVideoToStorage(String _userID, String _path) async {
    try {
      progress = 0;
      notifyListeners();
      CloudinaryResponse response;
      var cloudinary = CloudinaryPublic(CLOUD_NAME, UPLOAD_PRESET, cache: false);
      response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(_path, folder: 'videos/$_userID', resourceType: CloudinaryResourceType.Auto),
        onProgress: (count, total) {
          progress = (count / total) * 100;
          print("PROGRESS: " + progress.toString());
          notifyListeners();
        },
      );

      return response.secureUrl;
    } catch (e) {
      print(e);
    }
  }
}
