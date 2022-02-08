import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  final db = FirebaseFirestore.instance;

  Future<DocumentReference<Map<String, dynamic>>?> memeCard(
      Map<String, dynamic> cardData) async {
    try {
      final cardId = await db.collection('meme').add(cardData);
      print("Try block message $cardId");
      if (cardId.id.isNotEmpty) {
        return cardId;
      } else {
        return null;
      }
    } catch (e) {
      print("Catch block error $e");
      return null;
    }
  }
}
