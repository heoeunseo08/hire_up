class DetailJobModel {
  final int id;
  final String companyName;
  final String companyLogo;
  final String jobTitle;
  final String recruitStatus;
  final String location;
  final String career;
  final String salary;
  final String employmentType;
  final String deadline;
  final String positionIntro;
  final List<String> tasks;
  final List<String> qualifications;
  final List<String> benefits;

  DetailJobModel({
    required this.id,
    required this.companyName,
    required this.companyLogo,
    required this.jobTitle,
    required this.recruitStatus,
    required this.location,
    required this.career,
    required this.salary,
    required this.employmentType,
    required this.deadline,
    required this.positionIntro,
    required this.tasks,
    required this.qualifications,
    required this.benefits,
  });

  factory DetailJobModel.from(Map<String, dynamic> json) => DetailJobModel(
    id: json  ['id'],
    companyName: json['companyName'],
    companyLogo: json['companyLogo'],
    jobTitle: json['jobTitle'],
    recruitStatus: json['recruitStatus'],
    location: json['location'],
    career: json['career'],
    salary: json['salary'],
    employmentType: json['employmentType'],
    deadline: json['deadline'],
    positionIntro: json['positionIntro'],
    tasks: List<String>.from(json['tasks']),
    qualifications: List<String>.from(json['qualifications']),
    benefits: List<String>.from(json['benefits']),
  );
}
