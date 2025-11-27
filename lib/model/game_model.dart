class Game {
  Game({
    this.id,
    this.userId,
    required this.name,
    required this.plataform,
    required this.gender,
    required this.realeaseyear,
    required this.gamecompany,
    required this.classification,
    required this.price,
    this.img,
  });

  String? id;
  String? userId;
  String name;
  String plataform;
  String gender;
  String realeaseyear;
  String gamecompany;
  String classification;
  String price;
  String? img;

  factory Game.fromFirestore(Map<String, dynamic> json, String documentId) {
    return Game(
      id: documentId,
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      plataform: json['plataform'] ?? '',
      gender: json['gender'] ?? '',
      realeaseyear: json['realeaseyear'] ?? '',
      gamecompany: json['gamecompany'] ?? '',
      classification: json['classification'] ?? '',
      price: json['price'] ?? '',
      img: json['img'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'plataform': plataform,
      'gender': gender,
      'realeaseyear': realeaseyear,
      'gamecompany': gamecompany,
      'classification': classification,
      'price': price,
      'img': img,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'],
      name: map['name'],
      plataform: map['plataform'],
      gender: map['gender'],
      realeaseyear: map['realeaseyear'],
      gamecompany: map['gamecompany'],
      classification: map['classification'],
      price: map['price'],
      img: map['img'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'plataform': plataform,
      'gender': gender,
      'realeaseyear': realeaseyear,
      'gamecompany': gamecompany,
      'classification': classification,
      'price': price,
      'img': img,
    };
  }
}