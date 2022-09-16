import 'package:alarme_notificacao/store/alarme.store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

final store = AlarmeStore();

class ListaMinutosHoras extends StatefulWidget {
  ListaMinutosHoras();

  @override
  State<ListaMinutosHoras> createState() => _ListaMinutosHorasState();
}

class _ListaMinutosHorasState extends State<ListaMinutosHoras> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          child: ListWheelScrollView.useDelegate(
            onSelectedItemChanged: (value) => setState(() {
              store.alterarMinuto(value);
            }),
            itemExtent: 50,
            diameterRatio: 2.5,
            useMagnifier: true,
            perspective: 0.005,
            physics: FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
                childCount: 24,
                builder: (context, index) {
                  return Container(
                    child: Center(
                        child: Text(
                      '${index < 10 ? '0' + index.toString() : index}',
                      style: TextStyle(
                          fontSize: 40,
                          color: store.minuto != index
                              ? Colors.black12
                              : Colors.black),
                    )),
                  );
                }),
          ),
        ),
        const SizedBox(width: 35),
        Text('${store.hora}'),
        Container(
          width: 50,
          child: ListWheelScrollView.useDelegate(
            onSelectedItemChanged: (value) => setState(() {
              store.alterarHora(value);
            }),
            itemExtent: 50,
            diameterRatio: 2,
            perspective: 0.005,
            physics: FixedExtentScrollPhysics(),
            childDelegate: ListWheelChildBuilderDelegate(
                childCount: 60,
                builder: (context, index) {
                  return Container(
                    child: Center(
                        child: Text(
                      '${index < 10 ? '0' + index.toString() : index}',
                      style: TextStyle(
                          fontSize: 40,
                          color: store.hora != index
                              ? Colors.black12
                              : Colors.black),
                    )),
                  );
                }),
          ),
        ),
      ],
    );
  }
}
