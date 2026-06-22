class RecommendedModel {
  final int id;
  final String companyName;
  final String companyLogo;
  final String jobTitle;
  final String location;
  final String employmentType;
  final String career;
  final String salary;
  final String deadlineLabel;
  final String dDay;
  final String recruitStatus;

  RecommendedModel({
    required this.id,
    required this.companyName,
    required this.companyLogo,
    required this.jobTitle,
    required this.location,
    required this.employmentType,
    required this.career,
    required this.salary,
    required this.deadlineLabel,
    required this.dDay,
    required this.recruitStatus,
  });

  factory RecommendedModel.fromJson(Map<String, dynamic> json) =>
      RecommendedModel(
        id: json['id'],
        companyName: json['companyName'],
        companyLogo: json['companyLogo'],
        jobTitle: json['jobTitle'],
        location: json['location'],
        employmentType: json['employmentType'],
        career: json['career'],
        salary: json['salary'],
        deadlineLabel: json['deadlineLabel'],
        dDay: json['dDay'],
        recruitStatus: json['recruitStatus'],
      );
}
