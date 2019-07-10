import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class SearchBar extends StatefulWidget {
  final String hintText;
  final void Function(String searchText) onCompleted;
  final List<String> Function(String prefix) suggestionsCallback;
  final VoidCallback onClear;

  SearchBar({
    @required this.hintText,
    @required this.onCompleted,
    @required this.suggestionsCallback,
    this.onClear,
  });

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasFocus);
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        TypeAheadField<String>(
          textFieldConfiguration: TextFieldConfiguration(
            focusNode: _focusNode,
            controller: _controller,
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: widget.hintText,
              hintStyle: TextStyle(fontSize: 18.0),
            ),
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            onEditingComplete: () {
              if (_controller.text.isEmpty) {
                widget.onClear();
              } else {
                widget.onCompleted(_controller.text);
              }
            },
          ),
          suggestionsCallback: widget.suggestionsCallback,
          onSuggestionSelected: (String suggestion) {
            setState(
              () => _controller.value = TextEditingValue(text: suggestion),
            );
            widget.onCompleted(suggestion);
          },
          itemBuilder: (BuildContext context, String suggestion) {
            return ListTile(title: Text(suggestion));
          },
          hideOnEmpty: true,
        ),
        Positioned(
          right: 0.0,
          top: 0.0,
          bottom: 0.0,
          child: FlatButton(
            child: Text(
              'CLEAR',
              style: TextStyle(color: _hasFocus ? Colors.black : Colors.grey),
            ),
            onPressed: () {
              _controller.clear();
              widget.onClear();
            },
          ),
        ),
      ],
    );
  }
}
