// chat_service.dart
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _currentChatUserId;

  String? get currentChatUserId => _currentChatUserId;

  void setCurrentChatUser(String userId) {
    _currentChatUserId = userId;
    notifyListeners();
  }

  // Send message from current user to selected user
  Future<void> sendMessage(String message, String receiverId) async {
    if (_auth.currentUser == null) return;

    final String currentUserId = _auth.currentUser!.uid;
    final String chatId = _getChatId(currentUserId, receiverId);
    final Timestamp timestamp = Timestamp.now();

    Map<String, dynamic> messageData = {
      'senderId': currentUserId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'read': false,
    };

    // Add to messages subcollection
    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(messageData);

    // Update last message in chat document
    await _firestore.collection('chats').doc(chatId).set({
      'lastMessage': message,
      'lastMessageTime': timestamp,
      'participants': [currentUserId, receiverId],
    }, SetOptions(merge: true));
  }

  // Get chat messages between current user and selected user
  Stream<QuerySnapshot> getMessages(String otherUserId) {
    if (_auth.currentUser == null) return const Stream.empty();

    final String currentUserId = _auth.currentUser!.uid;
    final String chatId = _getChatId(currentUserId, otherUserId);

    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Get list of chats for current user
  Stream<QuerySnapshot> getChats() {
    if (_auth.currentUser == null) return const Stream.empty();

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: _auth.currentUser!.uid)
        .orderBy('lastMessageTime', descending: true)
        .snapshots();
  }

  // Get user data
  Future<DocumentSnapshot> getUserData(String userId) {
    return _firestore.collection('users').doc(userId).get();
  }

  // Get all patients (for doctor)
  Stream<QuerySnapshot> getAllPatients() {
    return _firestore
        .collection('users')
        .where("email", isNotEqualTo: "doctor001@gmail.com")
        .snapshots();
  }

  String _getChatId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? '$userId1-$userId2'
        : '$userId2-$userId1';
  }
}