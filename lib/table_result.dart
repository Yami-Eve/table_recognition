import 'package:flutter/material.dart';

class MyTableScreen extends StatelessWidget {
  final List _data;
  final int _column;

  const MyTableScreen(this._data, this._column, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("表格结果"),
      ),
      body: MyTableContent(this._data, this._column),
    );
  }
}

class MyTableContent extends StatelessWidget {
  final List _data;
  final int _column;

  const MyTableContent(this._data, this._column, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _showTable(),
        ],
      ),
    );
  }

  Widget _showTable() {
    return Table(
      border: TableBorder.all(
        color: Colors.black,
      ),
      children: _getTableRow(),
    );
  }

  List<TableRow> _getTableRow() {
    List<TableRow> rows = [];
    List rowsList = [];
    List rowList = [];
    print(_data);
    for (int i = 0; i < _data.length; i++) {
      rowList.add(_data[i]);
      if ((i + 1) % _column == 0) {
        print('--------------------------------------');
        rowsList.add(rowList);
        print(rowList);
        rowList = [];
      }
    }
    for (int i = 0; i < rowsList.length; i++) {
      if (i == 0) {
        //表头
        rows.add(TableRow(
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
          ),
          children: _getRow(rowsList[i]),
        ));
      } else {
        rows.add(TableRow(children: _getRow(rowsList[i])));
      }
    }
    return rows;
  }

  List<Widget> _getRow(element) {
    List<Widget> row = [];
    element = element as List;
    element.forEach((element) {
      row.add(_getCell(element));
    });
    return row;
  }

  Widget _getCell(element) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Center(
        child: Text(element.toString()),
      ),
    );
  }
}
