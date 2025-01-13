class Student {
  final String id;
  final String schoolName;
  final String studentEmisId;
  final String studentName;
  final String dateOfBirth;
  final String gender;
  final String classLevel;
  final String groupCode;
  final String groupName;
  final String medium;
  final bool referralBool;
  final String? referral;
  final String caseStatus;
  final bool medicineBool;
  final String? medicine;

  Student({
    required this.id,
    required this.schoolName,
    required this.studentEmisId,
    required this.studentName,
    required this.dateOfBirth,
    required this.gender,
    required this.classLevel,
    required this.groupCode,
    required this.groupName,
    required this.medium,
    required this.referralBool,
    this.referral,
    required this.caseStatus,
    required this.medicineBool,
    this.medicine,
  });

  // Factory constructor to create an instance from JSON
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['_id'],
      schoolName: json['school_name'],
      studentEmisId: json['student_emis_id'],
      studentName: json['student_name'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      classLevel: json['class'],
      groupCode: json['group_code'],
      groupName: json['group_name'],
      medium: json['medium'],
      referralBool: json['referal_bool'] ?? false,
      referral: json['referal'],
      caseStatus: json['Case_Status'],
      medicineBool: json['Medicine_bool'] ?? false,
      medicine: json['Medicine'],
    );
  }
}
