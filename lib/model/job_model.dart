class JobModel {
  final int id;
  final String companyName;
  final String companyLogo;
  final String jobTitle;
  final String location;
  final String employmentType;
  final String career;
  final String salary;
  final String deadlineLabel;
  final int viewCount;
  final String createdAt;

  JobModel({
    required this.id,
    required this.companyName,
    required this.companyLogo,
    required this.jobTitle,
    required this.location,
    required this.employmentType,
    required this.career,
    required this.salary,
    required this.deadlineLabel,
    required this.viewCount,
    required this.createdAt,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
    id: json["id"],
    companyName: json["companyName"],
    companyLogo: json["companyLogo"],
    jobTitle: json["jobTitle"],
    location: json["location"],
    employmentType: json["employmentType"],
    career: json["career"],
    salary: json["salary"],
    deadlineLabel: json["deadlineLabel"],
    viewCount: json["viewCount"],
    createdAt: json["createdAt"],
  );
}
