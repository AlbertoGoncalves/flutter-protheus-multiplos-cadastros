class CompanyModel {
  final String id;
  final String company;

  CompanyModel({
    required this.id,
    required this.company,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> json) {
    return switch (json) {
      {
        'branchCode': String id,
        'branchDescription': String company,
      } =>
        CompanyModel(
          id: id,
          company: company,
        ),
      _ => throw ArgumentError('Invalid Json'),
    };
  }
}