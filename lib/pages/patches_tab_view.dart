import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data.dart';
import '../services/analytics.dart';

class PatchesTabView extends StatefulWidget {
  @override
  _PatchesTabViewState createState() => _PatchesTabViewState();
}

class _PatchesTabViewState extends State<PatchesTabView> {
  static const _patchKeys = [
    '9.23',
    '9.22',
  ];

  final ScrollController _scrollController = ScrollController();

  bool _showBackToTopButton = false;
  int _selectedPatchIndex = 0;
  String _markdownData = '';

  @override
  void initState() {
    super.initState();
    // Delay to keep a smooth tab transition.
    Future.delayed(Duration(seconds: 1), () {
      _selectPatchIndex(_selectedPatchIndex);
    });

    _scrollController.addListener(() {
      setState(() {
        _showBackToTopButton = _scrollController.offset >= 200;
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _selectPatchIndex(int index) {
    Data.fetchPatchMarkdown(_patchKeys[index]).then((String markdownData) {
      setState(() {
        _selectedPatchIndex = index;
        _markdownData = markdownData;
      });
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeOutExpo,
    );
  }

  Widget _buildPatchCips() {
    return Wrap(
      children: List<Widget>.generate(_patchKeys.length, (i) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 0.0),
          child: ChoiceChip(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.zero,
            label: Text(_patchKeys[i]),
            labelStyle: TextStyle(color: Colors.white),
            backgroundColor: Colors.grey[500],
            selectedColor: Colors.grey[900],
            selected: _selectedPatchIndex == i,
            onSelected: (_) => _selectPatchIndex(i),
          ),
        );
      }),
    );
  }

  Widget _buildPatchDetails() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      child: _markdownData.isEmpty
          ? Container(
              height: MediaQuery.of(context).size.height - 220.0,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : MarkdownBody(
              data: _markdownData,
              onTapLink: (String url) {
                Analytics.logOpenUrlEvent(url);
                launch(url);
              },
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                h2: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildPatchCips(),
              Divider(),
              _buildPatchDetails(),
            ],
          ),
        ),
      ),
      floatingActionButton: _showBackToTopButton
          ? FloatingActionButton(
              mini: true,
              child: Icon(Icons.arrow_upward),
              onPressed: _scrollToTop,
            )
          : null,
    );
  }
}
