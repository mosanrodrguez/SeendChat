class User {
  final String id; final String phoneNumber; final String? username; final String? fullName;
  final String? info; final String? photoUrl; String status; String? lastSeen;

  User({required this.id, required this.phoneNumber, this.username, this.fullName, this.info = '¡Hola! Estoy usando Seend.', this.photoUrl, this.status = 'offline', this.lastSeen});

  factory User.fromJson(Map<String, dynamic> j) => User(id: j['id'] ?? '', phoneNumber: j['phoneNumber'] ?? '', username: j['username'], fullName: j['fullName'], info: j['info'] ?? '¡Hola! Estoy usando Seend.', photoUrl: j['photoUrl'], status: j['status'] ?? 'offline', lastSeen: j['lastSeen']);

  String get displayName => fullName ?? username ?? 'Usuario';
  String get initial => displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
}
