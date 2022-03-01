import 'package:expense_tracker/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return SizedBox(
      height: 600,
      child: transactions.isEmpty
          ? Column(
              children: [
                Text(
                  "No Transaction added yet",
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 50),
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    'assets/images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                var transaction = transactions[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child:
                            FittedBox(child: Text('\$${transaction.amount}')),
                      ),
                    ),
                    title: Text(
                      transaction.title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd().format(transaction.date),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      color: Theme.of(context).errorColor,
                      onPressed: () =>
                          _deleteTransactionHandler(transaction.id),
                    ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
