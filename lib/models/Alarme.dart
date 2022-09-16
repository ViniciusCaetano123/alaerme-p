class Alarme {
  int? id;
  int hora;
  int minuto;
  bool domingo;
  bool sabado;
  bool segunda;
  bool terca;
  bool quarta;
  bool quinta;
  bool sexta;

  Alarme({
    required this.hora,
    required this.minuto,
    required this.domingo,
    required this.sabado,
    required this.segunda,
    required this.terca,
    required this.quarta,
    required this.quinta,
    required this.sexta,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'hora': hora,
      'minuto': minuto,
      'domingo': domingo,
      'sabado': sabado,
      'segunda': segunda,
      'terca': terca,
      'quarta': quarta,
      'quinta': quinta,
      'sexta': sexta
    };

    return map;
  }
}
