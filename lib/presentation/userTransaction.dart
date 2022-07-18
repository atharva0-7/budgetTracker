import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import '../models/transactions.dart';
import 'addTransactions.dart';

class UserTransaction extends StatelessWidget {
  final List<Transaction> transactions;
  Function _deleteTransaction;
  UserTransaction(this.transactions, this._deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.45,
      child: transactions.isEmpty
          ? Center(
              child: Text(
              "No transactions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (ctx, index) {
                return Card(
                    elevation: 8,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                    // child: Row(children: [
                    // AmountBox(transactions[index]),
                    //   ItemDescriptionBox(transactions[index])
                    // ]),
                    child: ListTile(
                      trailing: IconButton(
                          onPressed: () {
                            _deleteTransaction(transactions[index].id);
                          },
                          icon: Icon(Icons.delete)),
                      title: Text(
                        transactions[index].title,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(DateFormat()
                          .add_yMMMd()
                          .format(transactions[index].dateTime)),
                      leading: CircleAvatar(
                        radius: 30,
                        child: FittedBox(
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text("Rs " +
                                    transactions[index].price.toString()))),
                      ),
                    ));
              }),
    );
  }
}
