import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CalculatorHomePage(),
    );
  }
}

class CalculatorHomePage extends StatefulWidget {
  @override
  _CalculatorHomePageState createState() => _CalculatorHomePageState();
}

class _CalculatorHomePageState extends State<CalculatorHomePage> {
  String displayText = '';
  String resultText = '';
  List<String> history = [];
  bool showHistory = false;

  void _evaluateExpression() {
    Parser p = Parser();
    Expression exp;
    try {
      exp = p.parse(displayText);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        resultText = eval.toString();
        history.add(displayText + ' = ' + resultText);
      });
    } catch (e) {
      setState(() {
        resultText = 'Error';
      });
    }
  }

  Widget buildButton(String text, {Color color = Colors.grey, Color textColor = Colors.white}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: color,
            onPrimary: textColor,
            padding: EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            setState(() {
              if (text == 'C') {
                displayText = '';
                resultText = '';
              } else if (text == '=') {
                _evaluateExpression();
              } else if (text == 'CE') {
                if (displayText.isNotEmpty) {
                  displayText = displayText.substring(0, displayText.length - 1);
                }
              } else {
                displayText += text;
              }
            });
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }

  Widget buildHistoryItem(String historyItem) {
    return ListTile(
      title: Text(
        historyItem,
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
      onTap: () {
        setState(() {
          displayText = historyItem.split(' = ')[0];
        });
      },
    );
  }

  Widget buildHistory() {
    return Drawer(
      child: Container(
        color: Colors.grey[300],
        child: Column(
          children: [
            AppBar(
              title: Text('History'),
              backgroundColor: Colors.black87,
              automaticallyImplyLeading: false,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return buildHistoryItem(history[index]);
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  history.clear();
                });
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                onPrimary: Colors.white,
              ),
              child: Text('Clear History'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        backgroundColor: Colors.black87,
        actions: [
          IconButton(
            icon: Icon(showHistory ? Icons.clear : Icons.history),
            onPressed: () {
              setState(() {
                showHistory = !showHistory;
              });
            },
          ),
        ],
      ),
      drawer: showHistory ? buildHistory() : null,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.black,
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    displayText,
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    resultText,
                    style: TextStyle(color: Colors.greenAccent, fontSize: 48),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  buildButton('7', color: Colors.grey[850]!),
                  buildButton('8', color: Colors.grey[850]!),
                  buildButton('9', color: Colors.grey[850]!),
                  buildButton('/', color: Colors.orange, textColor: Colors.white),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton('4', color: Colors.grey[850]!),
                  buildButton('5', color: Colors.grey[850]!),
                  buildButton('6', color: Colors.grey[850]!),
                  buildButton('*', color: Colors.orange, textColor: Colors.white),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton('1', color: Colors.grey[850]!),
                  buildButton('2', color: Colors.grey[850]!),
                  buildButton('3', color: Colors.grey[850]!),
                  buildButton('-', color: Colors.orange, textColor: Colors.white),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton('0', color: Colors.grey[850]!),
                  buildButton('(', color: Colors.grey[850]!),
                  buildButton(')', color: Colors.grey[850]!),
                  buildButton('+', color: Colors.orange, textColor: Colors.white),
                ],
              ),
              Row(
                children: <Widget>[
                  buildButton('.', color: Colors.grey[850]!),
                  buildButton('C', color: Colors.red, textColor: Colors.white),
                  buildButton('CE', color: Colors.red, textColor: Colors.white),
                  buildButton('=', color: Colors.green, textColor: Colors.white),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
