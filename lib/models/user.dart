class User {
  final String id;
  final String phoneNumber;
  final String? username;
  final String? fullName;
  final String? info;
  final String? photoUrl;
  String status;
  String? lastSeen;

  User({
    required this.id,
    required this.phoneNumber,
    this.username,
    this.fullName,
    this.info = '¡Hola! Estoy usando Seend.',
    this.photoUrl,
    this.status = 'offline',
    this.lastSeen,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      username: json['username'],
      fullName: json['fullName'],
      info: json['info'] ?? '¡Hola! Estoy usando Seend.',
      photoUrl: json['photoUrl'],
      status: json['status'] ?? 'offline',
      lastSeen: json['lastSeen'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'phoneNumber': phoneNumber,
    'username': username,
    'fullName': fullName,
    'info': info,
    'photoUrl': photoUrl,
    'status': status,
    'lastSeen': lastSeen,
  };

  String get displayName => fullName ?? username ?? 'Usuario';
  String get initial => displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
}
