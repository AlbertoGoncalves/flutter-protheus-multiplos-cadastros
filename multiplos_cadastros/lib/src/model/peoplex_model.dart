class PeopleXModel {
  final String sFILIAL;
  final String sCODE;
  final String sNAME;


  PeopleXModel(
      {required this.sFILIAL,
      required this.sCODE,
      required this.sNAME});

  factory PeopleXModel.fromMap(Map<String, dynamic> json) {
    return switch (json) {
      {
        "ZZ1_FILIAL": final sFILIAL,
        "ZZ1_CODE": final sCODE,
        "ZZ1_NAME": final sNAME,
      } =>
        PeopleXModel(
          sFILIAL: sFILIAL.trim(),
          sCODE: sCODE.trim(),
          sNAME: sNAME.trim(),

        ),
      _ => throw ArgumentError('Invalid Json'),
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "ZZ1_FILIAL": sFILIAL,
      "ZZ1_CODE": sCODE,
      "ZZ1_NAME": sNAME,
      
    };
  }
}
