import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionItem extends StatefulWidget {
  const TransactionItem({
    Key key,
    @required this.transaction,
    @required Function(String p1) deleteTransactionHandler,
  })  : _deleteTransactionHandler = deleteTransactionHandler,
        super(key: key);

  final Transaction transaction;
  final Function(String p1) _deleteTransactionHandler;

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color bgColor;

  @override
  void initState() {
    super.initState();
    const availableColors = [Colors.red, Colors.black, Colors.blue];

    bgColor = availableColors[Random().nextInt(4)];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 5,
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: bgColor,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: FittedBox(child: Text('\$${widget.transaction.amount}')),
          ),
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width > 800
            ? TextButton.icon(
                onPressed: () =>
                    widget._deleteTransactionHandler(widget.transaction.id),
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style:
                    TextButton.styleFrom(primary: Theme.of(context).errorColor),
              )
            : IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () =>
                    widget._deleteTransactionHandler(widget.transaction.id),
              ),
      ),
    );
  }
}
