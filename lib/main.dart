import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'components/chart.dart';
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
    // Definir para o aplicativo rodar apenas em modo retrato
    //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight]);

    final ThemeData tema = ThemeData();
    return MaterialApp(
        home: MyHomePage(),
        theme: ThemeData(
          primarySwatch: Colors.purple,
          fontFamily: 'Belanosima',
          textTheme: ThemeData.light().textTheme.copyWith(
              titleMedium: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              labelMedium: TextStyle(
                color: Colors.white,
              )),
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
  final List<Transaction> _transactions = [];
  bool _showChart = false;
  List<Transaction> get _recentTransactions {
    return _transactions.where((tr) {
      // filtramos apenas as transações recentes
      return tr.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  _openTransactionFormModal(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return TransactionForm(_addTransaction);
        });
  }

  _addTransaction(String title, double value, DateTime date) {
    final newTransaction = Transaction(
      id: Random().nextDouble().toString(),
      title: title,
      value: value,
      date: date,
    );

    setState(() {
      _transactions.add(newTransaction);
    });

    Navigator.of(context).pop();
  }

  _removeTransaction(String id) {
    setState(() {
      // remove quando a função retornar true
      _transactions.removeWhere((tr) => tr.id == id);
    });
  }

  Widget _getIconButton(IconData icon, Function() fn) {
    return Platform.isIOS
        ? GestureDetector(
            onTap: fn,
            child: Icon(icon),
          )
        : IconButton(
            onPressed: fn,
            icon: Icon(icon),
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    bool isLandscape = mediaQuery.orientation == Orientation.landscape;

    final iconList = Platform.isIOS ? CupertinoIcons.refresh : Icons.list;
    final chartList =
        Platform.isIOS ? CupertinoIcons.refresh : Icons.show_chart;

    final actions = [
      if (isLandscape)
        _getIconButton(_showChart ? iconList : chartList, () {
          setState(() {
            _showChart = !_showChart;
          });
        }),
      _getIconButton(Platform.isIOS ? CupertinoIcons.add : Icons.add,
          () => _openTransactionFormModal(context)),
    ];

    final PreferredSizeWidget appBar =
        //Platform.isIOS
        //     ? CupertinoPageScaffold(
        //         navigationBar: CupertinoNavigationBar(
        //           middle: Text('Despesas Pessoais'),
        //           trailing: Row(
        //             mainAxisSize: MainAxisSize.min,
        //             children: actions,
        //           ),
        //         ),
        //       )
        //     : AppBar(
        //         title: Text(
        //           'Despesas Pessoas',
        //           style: TextStyle(fontSize: 20 * mediaQuery.textScaleFactor),
        //         ),
        //         actions: actions,
        //       );

        // final appBar = Platform.isIOS
        //     ? CupertinoNavigationBar(
        //         middle: Text('Despesas Pessoais'),
        //         trailing: Row(
        //           mainAxisSize: MainAxisSize.min,
        //           children: actions,
        //         ),
        //       )
        //     :
        AppBar(
      title: Text(
        'Despesas Pessoas',
        style: TextStyle(fontSize: 20 * mediaQuery.textScaleFactor),
      ),
      actions: actions,
    );

    final availableHeight = mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top;

    final bodyPage = SafeArea(
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // // Alternativa anterior usando switch
              // if (isLandscape)
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text('Exibir Gráfico'),
              // Aptative deixa no padrao do ios no ios e vice versa
              //       Switch.adaptive(
              //         value: _showChart,
              //         onChanged: (value) {
              //           setState(() {
              //             _showChart = value;
              //           });
              //         },
              //       ),
              //     ],
              //   ),
              if (_showChart || !isLandscape)
                Container(
                  height: availableHeight * (isLandscape ? 0.8 : 0.25),
                  child: Chart(_recentTransactions),
                ),
              if (!_showChart || !isLandscape)
                Container(
                  height: availableHeight * (isLandscape ? 1 : 0.7),
                  child: TransactionList(_transactions, _removeTransaction),
                ),
            ]),
      ),
    );

    return
        // return Platform.isIOS
        //     ? CupertinoPageScaffold(
        //         navigationBar: appBar,
        //         child: bodyPage,
        //       )
        //     :
        Scaffold(
      appBar: appBar,
      body: bodyPage,
      floatingActionButton: Platform.isIOS
          ? Container()
          : FloatingActionButton(
              onPressed: () => _openTransactionFormModal(context),
              child: Icon(Icons.add),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
