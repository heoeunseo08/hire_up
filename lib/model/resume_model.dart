class ResumeModel {

  final int id;
  final String title;
  final String updatedAt;
  final List<String> skills;

  ResumeModel({
    required this.id,
    required this.title,
    required this.updatedAt,
    required this.skills,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) => ResumeModel(
    id: json['id'],
    title: json['title'],
    updatedAt: json['updatedAt'],
    skills: json['skills'],
  );
}