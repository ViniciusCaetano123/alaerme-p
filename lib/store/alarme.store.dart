import 'package:mobx/mobx.dart';

part 'alarme.store.g.dart';

class AlarmeStore = _AlarmeStore with _$AlarmeStore;

abstract class _AlarmeStore with Store {
  @observable
  int hora = 0;

  int minuto = 0;

  @action
  void alterarHora(value) {
    hora = value;
  }

  @action
  void alterarMinuto(value) {
    minuto = value;
  }
}
