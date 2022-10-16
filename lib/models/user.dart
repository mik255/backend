import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  int id;
  String nome;
  String cnpj;
  String password;
  int isAtivo;
  DateTime dtCriacao;
  DateTime dtAutalizacao;
  User({
    required this.id,
    required this.nome,
    required this.cnpj,
    required this.password,
    required this.isAtivo,
    required this.dtCriacao,
    required this.dtAutalizacao,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'nome': nome,
      'cnpj': cnpj,
      'password': password,
      'isAtivo': isAtivo,
      'dtCriacao': dtCriacao.millisecondsSinceEpoch,
      'dtAutalizacao': dtAutalizacao.millisecondsSinceEpoch,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as int,
      nome: map['nome'] as String,
      cnpj: map['cnpj'] as String,
      password: map['password'] as String,
      isAtivo: map['is_ativo'] as int,
      dtCriacao: map['dt_criacao'],
      dtAutalizacao: map['dt_autalizacao'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return '{id: $id, nome: $nome, cnpj: $cnpj, password: $password, isAtivo: $isAtivo, dtCriacao: $dtCriacao, dtAutalizacao: $dtAutalizacao}';
  }
}
