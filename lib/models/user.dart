class User {
  final int id;
  final String name;
  final String imageUrl;

  const User({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        imageUrl = map['imageUrl'];

  Map<String, dynamic> toMap() => <String, dynamic>{
        'id': id,
        'name': name,
        'imageUrl': imageUrl,
      };
}
