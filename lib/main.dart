import 'package:flutter/material.dart';

import 'dart:math';

import '../models/transaction.dart';
import 'components/transaction_form.dart';
import 'components/transaction_list.dart';

main() => runApp(ExpensesApp());

class ExpensesApp extends StatelessWidget {
  const ExpensesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData tema = ThemeData();
    return MaterialApp(
        home: MyHomePage(),
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Belanosima',
          appBarTheme: AppBarTheme(
              // titleTextStyle: ThemeData.light().textTheme.copyWith(
              //       titleLarge: TextStyle(
              //         fontFamily: 'Belanosima',
              //       ),
              //     ),
              ),
        )
        // tema.copyWith(
        //   colorScheme: tema.colorScheme.copyWith(
        //     primary: Colors.purple,
        //     secondary: Colors.amber,
        //   ),
        //   textTheme: tema.textTheme.copyWith(
        //     headline6: TextStyle(
        //       fontFamily: 'OpenSans',
        //       fontSize: 18,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.black,
        //     ),
        //   ),
        //   appBarTheme: AppBarTheme(
        //     titleTextStyle: TextStyle(
        //       fontFamily: 'OpenSans',
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),
        );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _transactions = [
    Transaction(
      id: 't1',
      title: 'Tenis de corrida',
      value: 22,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't1',
      title: 'Tenis de corrida',
      value: 22,
      date: DateTime.now(),
    ),
  ];

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  _addTransaction(String title, double value) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: DateTime.now(),
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Despesas Pessoas'),
        actions: [
          IconButton(
            onPressed: () => _openTransactionFormModal(context),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                width: double.infinity,
                child: Card(
                  color: Colors.blue,
                  child: Text('Gráfico'),
                  elevation: 5,
                ),
              ),
              TransactionList(_transactions),
            ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openTransactionFormModal(context),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
