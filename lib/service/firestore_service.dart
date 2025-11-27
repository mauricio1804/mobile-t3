import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jogos_videogame_t3/model/game_model.dart';

class FirestoreService {
  final CollectionReference games = FirebaseFirestore.instance.collection(
    'games',
  );

  Future<void> create(Game game) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final gameData = game.toFirestore();
    gameData['userId'] = uid;
    return games.add(gameData);
  }

  Stream<List<Game>> read() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    return games
         .where('userId', isEqualTo: uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Game.fromFirestore(
              doc.data() as Map<String, dynamic>,
              doc.id,
            );
          }).toList();
        });
  }
  Future<void> update(String docID, Game card) async {
    final data = card.toFirestore();
    final uid = FirebaseAuth.instance.currentUser!.uid;
    data['userId'] = uid;
    return games.doc(docID).update(data);
  }
  Future<void> delete(String docID) {
    return games.doc(docID).delete();
  }
}
