import 'package:flutter/material.dart';
import 'card.dart';

class CardSection extends StatefulWidget {
  final ValueChanged<String> onTransactionTypeSelected;

  const CardSection({Key? key, required this.onTransactionTypeSelected})
      : super(key: key);

  @override
  _CardSectionState createState() => _CardSectionState();
}

class _CardSectionState extends State<CardSection> {
  String _selectedTransactionType = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: CardComponent(
              color: Colors.blue,
              transactionType: "Type A",
              isSelected: _selectedTransactionType == 'Type A',
              onTap: () {
                setState(() {
                  _selectedTransactionType = 'Type A';
                });
                widget.onTransactionTypeSelected('Type A');
              },
            ),
          ),
          CardComponent(
            color: Color(0xff060F27),
            transactionType: "Type B",
            isSelected: _selectedTransactionType == 'Type B',
            onTap: () {
              setState(() {
                _selectedTransactionType = 'Type B';
              });
              widget.onTransactionTypeSelected('Type B');
            },
          ),
          CardComponent(
            color: Colors.red,
            transactionType: "Type C",
            isSelected: _selectedTransactionType == 'Type C',
            onTap: () {
              setState(() {
                _selectedTransactionType = 'Type C';
              });
              widget.onTransactionTypeSelected('Type C');
            },
          )
        ],
      ),
    );
  }
}
