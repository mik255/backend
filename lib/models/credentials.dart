class Credentials {
  String? cnpj;
  String? password;

  Credentials({this.cnpj, this.password});

  Credentials.fromJson(Map<String, dynamic> json) {
    cnpj = json['cnpj'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cnpj'] = this.cnpj;
    data['password'] = this.password;
    return data;
  }
}
