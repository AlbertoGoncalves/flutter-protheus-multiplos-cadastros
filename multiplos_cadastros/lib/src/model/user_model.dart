sealed class UserModel {
  final String id;
  final String name;
  final String? email;
  final String? department;
  final String? jobFunction;
  final String? avatar;
  final String? password;

    UserModel({
    required this.id,
    required this.name,
    this.email,
    this.department,
    this.jobFunction,
    this.avatar,
    this.password
  });


  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModelADM.fromMap(json);
    // return switch (json['profile']) {
    //   'ADM' => UserModelADM.fromMap(json),
    //   'EMPLOYEE' => UserModelEmployee.fromMap(json),
    //   _ => throw ArgumentError('User profile not found')
    // };
  }
}

class UserModelADM extends UserModel {
  final List<String>? workDays;
  final List<int>? workHours;

  UserModelADM({
    required super.id,
    required super.name,
    super.email,
    super.department,
    super.jobFunction,
    super.password,
    super.avatar,
    this.workDays,
    this.workHours,
  });

  factory UserModelADM.fromMap(Map<String, dynamic> json) {
    return switch (json) {
      {
        'id': final String id,
        'displayName': final String name,
        'externalId': final String email,
        'title': final String jobFunction,
        'department': final String department,
      } =>
        UserModelADM(
          id: id,
          name: name,
          email: email,
          jobFunction: jobFunction,
          department: department,
          avatar: json['avatar'],
          workDays: json['work_days']?.cast<String>(),
          workHours: json['work_hours']?.cast<int>(),
        ),
      _ => throw ArgumentError('Invalid Json')
    };
  }
}

class UserModelEmployee extends UserModel {
  final String companyId;
  final List<String> workDays;
  final List<int> workHours;

  UserModelEmployee({
    required super.id,
    required super.name,
    super.email,
    super.department,
    super.jobFunction,
    super.avatar,
    required this.companyId,
    required this.workDays,
    required this.workHours,
  });

  factory UserModelEmployee.fromMap(Map<String, dynamic> json) {
    return switch (json) {
      {
        'userID': final String id,
        'name': final String name,
        'email': final String email,
        'company_id': final String companyId,
        'work_days': final List workDays,
        'work_hours': final List workHours,
      } =>
        UserModelEmployee(
          id: id,
          name: 'name',
          email: 'email',
          // name: name,
          // email: email,
          avatar: json['avatar'],
          companyId: companyId,
          workDays: workDays.cast<String>(),
          workHours: workHours.cast<int>(),
        ),
      _ => throw ArgumentError('Invalid Json'),
    };
  }
}
