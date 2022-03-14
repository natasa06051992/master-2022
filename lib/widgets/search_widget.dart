import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  final String hintText;
  final String text;
  final ValueChanged<String> onChanged;
  const SearchWidget(
      {Key? key,
      required this.hintText,
      required this.text,
      required this.onChanged})
      : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          icon: Icon(Icons.search),
          suffixIcon: widget.text.isNotEmpty
              ? GestureDetector(
                  child: Icon(Icons.close),
                  onTap: () {
                    controller.clear();
                    widget.onChanged('');
                    FocusScope.of(context).requestFocus();
                  },
                )
              : null,
          hintText: widget.hintText,
          border: InputBorder.none),
      onChanged: widget.onChanged,
    );
  }
}
