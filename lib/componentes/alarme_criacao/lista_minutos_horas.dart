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
  double _constIconSize = 50;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Stack(
        children: [
          Positioned(
            child: Center(
              child: Text(
                ':',
                style: TextStyle(fontSize: 40),
              ),
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  child: ListWheelScrollView.useDelegate(
                    onSelectedItemChanged: (value) => setState(() {
                      store.alterarMinuto(value);
                    }),
                    itemExtent: 65,
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
                                  fontSize: 50,
                                  color: store.minuto != index
                                      ? Colors.black12
                                      : Colors.black),
                            )),
                          );
                        }),
                  ),
                ),
                const SizedBox(width: 35),
                Container(
                  width: 80,
                  child: ListWheelScrollView.useDelegate(
                    onSelectedItemChanged: (value) => setState(() {
                      store.alterarHora(value);
                    }),
                    itemExtent: 65,
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
                                  fontSize: 50,
                                  color: store.hora != index
                                      ? Colors.black12
                                      : Colors.black),
                            )),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
