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

  String get deadline{
    if(deadlineLabel == '마감') return '마감';
    if(deadlineLabel == '오늘 마감') return '오늘 마감';

    final match = RegExp(r'(\d+)일 전').firstMatch(deadlineLabel);
    if(match != null){
      final days = int.parse(match.group(1)!);
      if(days <= 7)return '$days일 전';
    }
    return '';
  }
}
