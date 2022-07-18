import 'package:budget_check/presentation/addTransactions.dart';
import 'package:budget_check/presentation/chart.dart';

import 'package:budget_check/presentation/userTransaction.dart';

import 'models/transactions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyHomePage());
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Transaction> _transactions = [];

  void _addTransaction(String title, int amount, DateTime date) {
    final transactionTx = Transaction(
        dateTime: date,
        price: amount,
        title: title,
        id: DateTime.now().toString());

    setState(() {
      _transactions.add(transactionTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((element) => element.id == id);
    });
  }

  List<Transaction> get recentTransaction {
    return _transactions.where((tx) {
      return tx.dateTime.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Budget Check"),
        ),
        body: SingleChildScrollView(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Chart(recentTransaction),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: UserTransaction(_transactions, _deleteTransaction),
              ),
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
              elevation: 20,
              child: Icon(Icons.add),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return AddTransaction(_addTransaction);
                    });
              }),
        ),
      ),
    );
  }
}
