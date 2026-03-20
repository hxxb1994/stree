class User {
  final bool led;
  final bool watter;

  User({required this.led, required this.watter});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(led: json['led'], watter: json['watter']);
  }
}
