import 'package:alarme_notificacao/models/AlarmeProvider.dart';
import 'package:alarme_notificacao/models/Semana.dart';
import 'package:alarme_notificacao/store/alarme.store.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sqflite/sqflite.dart';
import 'models/Alarme.dart';
import 'services/DataBase.dart';
import 'componentes/alarme_criacao/lista_minutos_horas.dart';

final store = AlarmeStore();

class AlarmeCriacaoPage extends StatefulWidget {
  const AlarmeCriacaoPage({Key? key}) : super(key: key);

  @override
  State<AlarmeCriacaoPage> createState() => _AlarmeCriacaoPage();
}

class _AlarmeCriacaoPage extends State<AlarmeCriacaoPage> {
  DateTime _dateTime = DateTime.now();

  Future<int> _addItem() async {
    int id = 0;
    await AlarmeProvider.createAlarme(
      'Alarme 1',
      store.hora,
      store.minuto,
      _repeat[0].isSelect ? 1 : 0,
      _repeat[1].isSelect ? 1 : 0,
      _repeat[2].isSelect ? 1 : 0,
      _repeat[3].isSelect ? 1 : 0,
      _repeat[4].isSelect ? 1 : 0,
      _repeat[5].isSelect ? 1 : 0,
      _repeat[6].isSelect ? 1 : 0,
    ).then((value) {
      id = value;
    });
    return id;
  }

  final _repeat = [
    Semana('S', false, 1),
    Semana('T', false, 2),
    Semana('Q', false, 3),
    Semana('Q', false, 4),
    Semana('S', false, 5),
    Semana('S', false, 6),
    Semana('D', false, 7),
  ];
  void criarAlarme() async {
    int id = await _addItem();
    print(id);
    final lista = AlarmeProvider.getItems();
    //store._journals =
    String localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    print(localTimeZone);
    /* _repeat.forEach((e) => {
          print(e),
          if (e.isSelect)
            {
              AwesomeNotifications().createNotification(
                content: NotificationContent(
                    id: id + e.weekday,
                    notificationLayout: NotificationLayout.BigText,
                    channelKey: 'basic_channel',
                    title: 'Simple Notification',
                    body: 'Simple body',
                    category: NotificationCategory.Alarm,
                    fullScreenIntent: true,
                    criticalAlert: true,
                    displayOnBackground: true,
                    displayOnForeground: true,
                    wakeUpScreen: true),
                schedule: NotificationCalendar(
                  weekday: e.weekday,
                  hour: store.hora,
                  millisecond: 0,
                  second: 0,
                  minute: store.minuto,
                  timeZone: localTimeZone,
                  preciseAlarm: true,
                ),
              )
            }
        });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0396FF),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Container(
            child: Column(children: [
              Container(
                height: 70 -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
                child: const Text('<'),
              ),
              SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: constraints.maxHeight -
                      70 -
                      MediaQuery.of(context).padding.top -
                      MediaQuery.of(context).padding.bottom,
                  padding: const EdgeInsets.all(20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0)),
                  ),
                  child: Column(
                    children: [
                      Container(height: 200, child: ListaMinutosHoras()),
                      const SizedBox(height: 50),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Repetir',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      const SizedBox(height: 8),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: _repeat.map((e) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  e.isSelect = !e.isSelect;
                                });
                              },
                              child: Container(
                                  child: Text(
                                    '${e.text}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      color: e.text == 'D'
                                          ? e.isSelect
                                              ? Colors.red
                                              : Colors.red[200]
                                          : e.isSelect
                                              ? Color(0xff0396FF)
                                              : Colors.grey[300])),
                            );
                          }).toList()),
                      const SizedBox(height: 45),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => {AwesomeNotifications().cancelAll()},
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          ElevatedButton(
                              style: ButtonStyle(),
                              onPressed: criarAlarme,
                              child: Text('Salvar'))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]),
          );
        }),
      ),
    );
  }
}
