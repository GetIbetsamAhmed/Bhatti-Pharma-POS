class UserLogin {
  String? id;
  String? email;
  bool? emailConfirmed;
  String? passwordHash;
  String? securityStamp;
  String? phoneNumber;
  bool? phoneNumberConfirmed;
  bool? twoFactorEnabled;
  String? userName;

  UserLogin({
    this.id,
    this.email,
    this.emailConfirmed,
    this.passwordHash,
    this.securityStamp,
    this.phoneNumber,
    this.phoneNumberConfirmed,
    this.twoFactorEnabled,
    this.userName,
  });

  UserLogin.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    email = json['Email'];
    emailConfirmed = json['EmailConfirmed'];
    passwordHash = json['PasswordHash'];
    securityStamp = json['SecurityStamp'];
    phoneNumber = json['PhoneNumber'];
    phoneNumberConfirmed = json['PhoneNumberConfirmed'];
    twoFactorEnabled = json['TwoFactorEnabled'];
    userName = json['UserName'];
  }
}
