class Pokemon {
  final String name;
  final String imageUrl;
  final int hp;
  final int attack;
  final int defense;

  Pokemon({
    required this.name,
    required this.imageUrl,
    required this.hp,
    required this.attack,
    required this.defense,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'imageUrl': imageUrl,
        'hp': hp,
        'attack': attack,
        'defense': defense,
      };

  factory Pokemon.fromJson(Map<String, dynamic> j) => Pokemon(
        name: j['name'],
        imageUrl: j['imageUrl'],
        hp: j['hp'],
        attack: j['attack'],
        defense: j['defense'],
      );
}
