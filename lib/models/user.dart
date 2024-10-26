class User {
  final String id;
  final String name;
  final int age;

  User({
    required this.id,
    required this.name,
    required this.age,
  });

  @override
  String toString() => 'User(id: $id, name: $name, age: $age)';
}
