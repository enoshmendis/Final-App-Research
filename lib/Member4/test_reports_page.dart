import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mlvapp/Member4/report_page.dart';
import 'package:mlvapp/provider/reports_page_provider.dart';
import 'package:mlvapp/shared/custom_list_view_tiles.dart';
import 'package:mlvapp/shared/refresh_widget.dart';

import 'package:mlvapp/utility/utils.dart';
import 'package:provider/provider.dart';

class TestReportsPage extends StatefulWidget {
  final String uid;
  const TestReportsPage({super.key, required this.uid});

  @override
  State<TestReportsPage> createState() => _TestReportsPageState();
}

class _TestReportsPageState extends State<TestReportsPage> {
  late String _uid;
  late double _deviceHeight;
  late double _deviceWidth;

  final keyRefresh = GlobalKey<RefreshIndicatorState>();

  ScrollController _scrollController = ScrollController();
  bool _pageLoading = false;

  late ReportsPageProvider _pageProvider;

  Future loadList() async {
    setState(() {
      _pageLoading = true;
    });

    await _pageProvider.getTestReports();

    setState(() {
      _pageLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _uid = widget.uid;
    _deviceHeight = deviceHeight(context);
    _deviceWidth = deviceWidth(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ReportsPageProvider>(
          create: (_) => ReportsPageProvider(_uid),
        ),
      ],
      child: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Builder(builder: (BuildContext _context) {
      _pageProvider = _context.watch<ReportsPageProvider>();
      return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.green,
          backgroundColor: Colors.white,
          title: const Text(
            'Test Reports',
          ),
        ),
        body: RefreshWidget(
          keyRefresh: keyRefresh,
          onRefresh: loadList,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: _deviceWidth * 0.02),
            width: _deviceWidth,
            height: _deviceHeight,
            child: _pageProvider.loading && !_pageLoading
                ? const Center(
                    child: SpinKitThreeBounce(color: Colors.blue),
                  )
                : _pageProvider.tests.isEmpty
                    ? const Center(
                        child: Text(
                          "No reports available.",
                          style: TextStyle(color: Colors.black),
                        ),
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _scrollController,
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        itemCount: _pageProvider.tests.length,
                        itemBuilder: (context, index) {
                          final test = _pageProvider.tests[index];
                          return CustomColorListViewTile(
                            onTap: () {
                              //Todo: view report
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ReportPage(test: test)),
                              );
                            },
                            leading: Text(
                              (index + 1).toString(),
                              style: TextStyle(fontSize: 24),
                            ),
                            height: 50,
                            title: DateFormat("yyyy-MM-dd").format(test.timestamp),
                            subtitle: test.deppressionResult != ""
                                ? "Depression : ${test.deppressionResult}"
                                : test.anxietyResult != ""
                                    ? "Anxiety : ${test.anxietyResult}"
                                    : test.stressResult != ""
                                        ? "Stress : ${test.stressResult}"
                                        : "",
                            isSelected: false,
                            color: Colors.black,
                          );
                        },
                      ),
          ),
        ),
      );
    });
  }
}
