import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AdaptativeDatePicker extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateChanged;
  const AdaptativeDatePicker(
      {required this.selectedDate, required this.onDateChanged});

  _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      onDateChanged(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? Container(
            height: 180,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              maximumDate: DateTime.now(),
              initialDateTime: DateTime.now(),
              minimumDate: DateTime(2019),
              onDateTimeChanged: onDateChanged,
            ),
          )
        : Container(
            height: 70,
            child: Row(children: [
              Expanded(
                child: Text(
                  selectedDate == null
                      ? 'Nenhuma data selecionada'
                      : 'Data Selecionada: ${DateFormat('dd/MM/y').format(selectedDate)}',
                ),
              ),
              TextButton(
                onPressed: () => _showDatePicker(context),
                child: Text('Selecionar Data'),
              )
            ]),
          );
  }
}
