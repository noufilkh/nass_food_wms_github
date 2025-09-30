class Userinformation {
  final String username;
  final String userid;
  final String organizationname;
  final String organizationcode;
  final String organizationid;
  final String userallowrecieptid;

  Userinformation({
    required this.username,
    required this.userid,
    required this.organizationname,
    required this.organizationcode,
    required this.organizationid,
    required this.userallowrecieptid,
  });

  factory Userinformation.fromJson(Map<String, dynamic> json) {
    return Userinformation(
      username: (json['USER_NAME'] == null) ? "" : json['USER_NAME'],
      userid: (json['FND_USER_ID'] == null) ? "" : json['FND_USER_ID'],
      organizationname:
          (json['ORGANIZATION_NAME'] == null) ? "" : json['ORGANIZATION_NAME'],
      organizationcode:
          (json['ORGANIZATION_CODE'] == null) ? "" : json['ORGANIZATION_CODE'],
      organizationid:
          (json['ORGANIZATION_ID'] == null) ? "" : json['ORGANIZATION_ID'],
      userallowrecieptid:
          (json['RECEIPT_ALLOWED'] == null) ? "" : json['RECEIPT_ALLOWED'],
    );
  }
}
