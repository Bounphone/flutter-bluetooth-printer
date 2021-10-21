import 'package:flutter_bluetooth_printer/library/bluetooth_print.dart';
import 'package:flutter_bluetooth_printer/library/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrintPage extends StatefulWidget {
  late List<Map<String, dynamic>> data;
  PrintPage({required this.data});
  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;
  List<BluetoothDevice> device = [];
  String deviceMsg = '';
  final f = NumberFormat('\$###,###.00', "en_US");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance
        ?.addPostFrameCallback((timeStamp) => {initPrinter()});
  }

  Future<void> initPrinter() async {
    bluetoothPrint.startScan(timeout: Duration(seconds: 2));

    if (!mounted) return;
    bluetoothPrint.scanResults.listen((event) {
      if (!mounted) return;
      setState(() => {device = event});
      if (device.isEmpty) {
        setState(() {
          deviceMsg = 'No device';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select printer'),
      ),
      body: device.isEmpty
          ? Center(
              child: Text(deviceMsg),
            )
          : ListView.builder(
              itemCount: device.length,
              itemBuilder: (c, i) => ListTile(
                    leading: Icon(Icons.print),
                    title: Text(device[i].name.toString()),
                    subtitle: Text(device[i].address.toString()),
                    onTap: () {
                      startPrint(device[i]);
                    },
                  )),
    );
  }

  Future<void> startPrint(BluetoothDevice device) async {
    if (device != null && device.address != null) {
      await bluetoothPrint.connect(device);

      Map<String, dynamic> config = Map();
      List<LineText> list = [];

      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Grocery App',
          width: 2,
          weight: 2,
          height: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      for (var i = 0; i < widget.data.length; i++) {
        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: widget.data[i]['title'],
            weight: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 1));
        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content:
                '${f.format(this.widget.data[i]['price'])} x ${this.widget.data[i]['tu']}',
            align: LineText.ALIGN_LEFT,
            linefeed: 1));
      }
    }
  }
}
