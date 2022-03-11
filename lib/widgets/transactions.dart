import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';

import 'transaction_item.dart';

class Transactions extends StatelessWidget {
  final List<Transaction> transactions;
  final Function(String) _deleteTransactionHandler;

  const Transactions(
    this.transactions,
    this._deleteTransactionHandler, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (ctx, constraints) {
            return Column(
              children: [
                Text(
                  "No Transaction added yet",
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: constraints.maxHeight * 0.1),
                SizedBox(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView(
            children: transactions.map((transaction) {
            return TransactionItem(
                key: ValueKey(transaction.id),
                transaction: transaction,
                deleteTransactionHandler: _deleteTransactionHandler);
          }).toList());
  }
}
