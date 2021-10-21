import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_printer/print_page.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  List<Map<String, dynamic>> data = [
    {'title': 'Cadbury Dairy Milk', 'price': 25, 'tu': 2},
    {'title': 'Cadbury Dairy Milk', 'price': 25, 'tu': 2},
    {'title': 'Cadbury Dairy Milk', 'price': 25, 'tu': 2},
    {'title': 'Cadbury Dairy Milk', 'price': 25, 'tu': 2},
  ];
  final f = NumberFormat('\$###,###.00', "en_US");
  @override
  Widget build(BuildContext context) {
    int total = 0;
    total = data
        .map((e) => e['price'] * e['tu'])
        .reduce((value, element) => value + element);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My printer'),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (c, i) => ListTile(
                    title: Text(
                      data[i]['title'].toString(),
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                        '${f.format(data[i]['price'])} x ${data[i]['tu']}'),
                    trailing: Text('${data[i]['price'] * data[i]['tu']}'),
                  ))),
          Container(
            color: Colors.grey,
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'Total: ${f.format(total)}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 80,
                ),
                Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => PrintPage(data: data)));
                      },
                      icon: Icon(Icons.print),
                      label: Text('Print'),
                      style: TextButton.styleFrom(
                          primary: Colors.white, backgroundColor: Colors.green),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
