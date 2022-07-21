import 'package:budget_check/models/transactions.dart';
import 'package:budget_check/presentation/chartBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  List<Transaction> recentTransaction;
  Chart(this.recentTransaction);
  List<Map> get groupTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0;

      for (var i = 0; i < recentTransaction.length; i++) {
        if (recentTransaction[i].dateTime.day == weekDay.day &&
            recentTransaction[i].dateTime.month == weekDay.month &&
            recentTransaction[i].dateTime.year == weekDay.year) {
          totalSum += recentTransaction[i].price;
        }
      }
      return {
        "day": DateFormat.E().format(weekDay).substring(0, 3),
        "amount": totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupTransactions.fold(0.0, (sum, item) {
      return sum + item["amount"];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupTransactions);
    return Card(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupTransactions.map((data) {
              return Flexible(
                child: ChartBar(
                    data['day'].toString(),
                    data['amount'],
                    totalSpending == 0.0
                        ? 0.0
                        : data['amount'] / totalSpending),
              );
            }).toList()));
  }
}
