class ProfileUser {
  final int id;
  final String name;
  final String email;
  final String intro;

  ProfileUser({
    required this.id,
    required this.name,
    required this.email,
    required this.intro,
  });

  factory ProfileUser.fromJson(Map<String, dynamic> json) => ProfileUser(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    intro: json["intro"],
  );
}

class ProfileStats {
  final int bookmarkCount;
  final int interviewCount;
  final int resumeCount;

  ProfileStats({
    required this.bookmarkCount,
    required this.interviewCount,
    required this.resumeCount,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) => ProfileStats(
    bookmarkCount: json["bookmarkCount"],
    interviewCount: json["interviewCount"],
    resumeCount: json["resumeCount"],
  );
}
