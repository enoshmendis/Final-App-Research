import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mlvapp/Models/mood.dart';
import 'package:mlvapp/Models/mood_record.dart';
import 'package:mlvapp/provider/MoodTrackPageProvide.dart';
import 'package:mlvapp/utility/consts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MoodPage extends StatefulWidget {
  final MoodTrackerPageProvider pageProvider;
  const MoodPage({super.key, required this.pageProvider});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late MoodTrackerPageProvider _pageProvider;
  late TooltipBehavior _tooltipBehavior;

  final _moodNames = kMoodList;

  // final List<Mood> _moodData = [
  //   Mood("Bad", DateTime.now().add(const Duration(days: 1))),
  //   Mood("Great", DateTime.now()),
  //   Mood("Awful", DateTime.now().subtract(const Duration(days: 1))),
  //   Mood("Okay", DateTime.now().subtract(const Duration(days: 2))),
  //   Mood("Good", DateTime.now().subtract(const Duration(days: 3))),
  //   Mood("Bad", DateTime.now().subtract(const Duration(days: 4))),
  // ];

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
        enable: true,
        builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
          return Container(color: Colors.white, child: Text('Mood : ${_moodNames[point.y]}'));
        });
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    _pageProvider = widget.pageProvider;
    return _pageProvider.loading
        ? const Center(
            child: SpinKitThreeBounce(color: Colors.blue),
          )
        : Container(
            child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(
                vertical: _deviceHeight * 0.02,
              ),
              child: SfCartesianChart(
                tooltipBehavior: _tooltipBehavior,
                title: ChartTitle(text: "Mood Flow"),
                legend: Legend(isVisible: false, position: LegendPosition.top),
                series: <ChartSeries>[
                  LineSeries<MoodRecord, int>(
                    sortingOrder: SortingOrder.descending,
                    sortFieldValueMapper: (MoodRecord mood, _) => mood.timestamp,
                    dataSource: _pageProvider.moodRecords,
                    yValueMapper: (MoodRecord mood, _) => _moodNames.indexOf(mood.mood.toString()),
                    xValueMapper: (MoodRecord mood, _) => mood.timestamp.day,
                    name: "Mood",
                    enableTooltip: true,
                    markerSettings: const MarkerSettings(isVisible: true),
                    yAxisName: "Day",
                  ),
                ],
                primaryXAxis: NumericAxis(
                  interval: 1,
                  title: AxisTitle(text: "Date"),
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                ),
                primaryYAxis: NumericAxis(
                  isInversed: true,
                  interval: 1,
                  maximum: 4,
                  axisLabelFormatter: (AxisLabelRenderDetails args) {
                    late num index = args.value;
                    late String text = kMoodEmojiList[index.toInt()];
                    late TextStyle textStyle;
                    textStyle = args.textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 22);
                    return ChartAxisLabel(text, textStyle);
                  },
                ),
              ),
            ),
          ));
  }

  // List<ChartSeries> _getCharts() {
  //   List<ChartSeries> _charts = [];
  //   if (_moodData.isNotEmpty) {
  //     _charts.add(
  //       SplineSeries<Mood, String>(
  //         dataSource: _moodData,
  //         xValueMapper: (Mood mood, _) => _moodNames.indexOf(mood.mood.toString()).toDouble(),
  //         yValueMapper: (Mood mood, _) => mood.dateTime.day.toDouble(),
  //         name: "Mood",
  //         enableTooltip: true,
  //         markerSettings: const MarkerSettings(isVisible: true),
  //       ),
  //     );
  //   }

  //   return _charts;
  // }
}
