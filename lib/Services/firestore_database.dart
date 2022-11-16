import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mlvapp/Models/chat_message.dart';
import 'package:mlvapp/Models/mood_record.dart';
import 'package:mlvapp/Models/test_model.dart';

const String USER_COLLECTION = "users";
const String MOOD_RECORD_COLLECTION = "mood_records";
const String TEST_COLLECTION = "tests";
const String CHAT_COLLECTION = "Chats";
const String MESSAGES_COLLECTION = "Messages";

class FirebaseDatabase {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // final String uid;
  String docID = '';

  FirebaseDatabase() {}

  Future<DocumentSnapshot> getUser(String _uid) {
    return _db.collection(USER_COLLECTION).doc(_uid).get();
  }

  Future<void> addUsersData(String _uid, String name, String usertype, String email, String docType) async {
    return await _db.collection(USER_COLLECTION).doc(_uid).set({
      'name': name,
      'usertype': usertype,
      'email': email,
      'doctype': docType,
      "last_active": DateTime.now().toUtc(),
    });
  }

  Future<void> updateUserLastSeenTime(String _uid) async {
    try {
      await _db.collection(USER_COLLECTION).doc(_uid).update({
        "last_active": DateTime.now().toUtc(),
      });
    } catch (e) {
      print(e);
    }
  }

  Future<QuerySnapshot> getDoctorList(String type) async {
    final result = await _db
        .collection(USER_COLLECTION)
        .where("usertype", isEqualTo: "Doctor")
        .where("doctype", isEqualTo: type)
        .get();

    return result;
  }

  Future<DocumentReference<Map<String, dynamic>>> addMoodRecord(MoodRecord _moodRecord) async {
    return await _db
        .collection(USER_COLLECTION)
        .doc(_moodRecord.uid)
        .collection(MOOD_RECORD_COLLECTION)
        .add(_moodRecord.toMap());
  }

  Future<QuerySnapshot> getMoodRecords(String _userId, DateTime from, DateTime to) async {
    final result = await _db
        .collection(USER_COLLECTION)
        .doc(_userId)
        .collection(MOOD_RECORD_COLLECTION)
        .where("timestamp", isGreaterThanOrEqualTo: from, isLessThan: to)
        .get();

    return result;
  }

  Future<QuerySnapshot> getLastMoodRecord(
    String _userId,
  ) async {
    final result = await _db
        .collection(USER_COLLECTION)
        .doc(_userId)
        .collection(MOOD_RECORD_COLLECTION)
        .orderBy("timestamp", descending: true)
        .limit(1)
        .get();

    return result;
  }

  Future<DocumentReference<Map<String, dynamic>>> addTest(Test _test) async {
    return await _db.collection(USER_COLLECTION).doc(_test.uid).collection(TEST_COLLECTION).add(_test.toMap());
  }

  Future<QuerySnapshot> getTests(String _userId) async {
    final result = await _db
        .collection(USER_COLLECTION)
        .doc(_userId)
        .collection(TEST_COLLECTION)
        .orderBy("timestamp", descending: true)
        .get();

    return result;
  }

  Stream<QuerySnapshot> getChatsForUser(String _uid) {
    return _db.collection(CHAT_COLLECTION).where('members', arrayContains: _uid).snapshots();
  }

  Future<QuerySnapshot> getLastMessageForChat(String _chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: true)
        .limit(1)
        .get();
  }

  Stream<QuerySnapshot> streamMessagesForChat(String _chatID) {
    return _db
        .collection(CHAT_COLLECTION)
        .doc(_chatID)
        .collection(MESSAGES_COLLECTION)
        .orderBy("sent_time", descending: false)
        .snapshots();
  }

  Future<void> addMessageToChat(String _chatID, ChatMessage _message) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatID).collection(MESSAGES_COLLECTION).add(_message.toJson());
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateChatData(String _chatID, Map<String, dynamic> _data) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatID).update(_data);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteChat(String _chatID) async {
    try {
      await _db.collection(CHAT_COLLECTION).doc(_chatID).delete();
    } catch (e) {
      print(e);
    }
  }

  Future<DocumentReference?> createChat(Map<String, dynamic> _data) async {
    try {
      return await _db.collection(CHAT_COLLECTION).add(_data);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> checkChatExist(String _user) async {
    final result = await _db.collection(CHAT_COLLECTION).where("members", arrayContains: _user).get();

    return result.docs.isNotEmpty;
  }
}
