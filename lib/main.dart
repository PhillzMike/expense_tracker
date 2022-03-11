import 'dart:io';

import 'package:expense_tracker/widgets/chart.dart';
import 'package:expense_tracker/widgets/new_transaction.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'models/transaction.dart';
import 'widgets/transactions.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.green,
        errorColor: Colors.red,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: const TextStyle(
                fontFamily: 'OpenSans',
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              button: const TextStyle(
                color: Colors.white,
              ),
            ),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactions = [];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _transactions
        .where(
          (transaction) => transaction.date.isAfter(
            DateTime.now().subtract(
              const Duration(days: 7),
            ),
          ),
        )
        .toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final transaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: chosenDate,
    );

    setState(() {
      _transactions.add(transaction);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return NewTransaction(
          addNewTransactionHandler: _addNewTransaction,
        );
      },
    );
  }

  void _deleteTransaction(String id) {
    setState(() {
      _transactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  Widget _getChartWidget(MediaQueryData mediaQuery, double scaleFactor,
      PreferredSizeWidget appBar) {
    return SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          scaleFactor,
      child: Chart(_recentTransactions),
    );
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, SizedBox transactionsWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.headline6,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (val) => setState(() => _showChart = val))
        ],
      ),
      _showChart
          ? _getChartWidget(mediaQuery, 0.7, appBar)
          : transactionsWidget,
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, SizedBox transactionsWidget) {
    return [_getChartWidget(mediaQuery, 0.3, appBar), transactionsWidget];
  }

  Widget _buildCupertinoAppBar() {
    return CupertinoNavigationBar(
      middle: const Text('Personal Expenses'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => _startAddNewTransaction(context),
            child: const Icon(CupertinoIcons.add),
          )
        ],
      ),
    );
  }

  Widget _buildDefaultAppBar() {
    return AppBar(
      title: const Text('Personal Expenses'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    final isPortrait = mediaQuery.orientation == Orientation.portrait;
    final PreferredSizeWidget appBar =
        Platform.isIOS ? _buildCupertinoAppBar() : _buildDefaultAppBar();

    var transactionsWidget = SizedBox(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: Transactions(_transactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!isPortrait)
              ..._buildLandscapeContent(mediaQuery, appBar, transactionsWidget),
            if (isPortrait)
              ..._buildPortraitContent(mediaQuery, appBar, transactionsWidget)
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
          );
  }
}
