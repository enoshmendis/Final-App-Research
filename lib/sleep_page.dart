import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mlvapp/Models/mood_record.dart';
import 'package:mlvapp/provider/MoodTrackPageProvide.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SleepPage extends StatefulWidget {
  final MoodTrackerPageProvider pageProvider;
  const SleepPage({super.key, required this.pageProvider});

  @override
  State<SleepPage> createState() => _SleepPageState();
}

class _SleepPageState extends State<SleepPage> {
  late double _deviceHeight;
  late double _deviceWidth;
  late MoodTrackerPageProvider _pageProvider;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(
      enable: true,
    );
    // builder: (dynamic data, dynamic point, dynamic series, int pointIndex, int seriesIndex) {
    //   return Container(color: Colors.white, child: Text('Mood : ${_moodNames[point.y]}'));
    // });
  }

  double getTimeValue(String time) {
    String endText = time.substring(time.length - 2, time.length);
    print(endText);
    List<String> values = time.substring(0, time.length - 2).split(":");
    print(values);
    double _timeValue = double.parse(values[0].trim()) + (double.parse(values[1].trim()) / 60);
    return _timeValue;
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
                  title: ChartTitle(text: "Sleep Record"),
                  legend: Legend(isVisible: false, position: LegendPosition.top),
                  series: <ChartSeries>[
                    RangeColumnSeries<MoodRecord, int>(
                      dataSource: _pageProvider.moodRecords,
                      xValueMapper: (MoodRecord data, _) => data.timestamp.day,
                      lowValueMapper: (MoodRecord data, _) => getTimeValue(data.sleepStart),
                      highValueMapper: (MoodRecord data, _) => getTimeValue(data.sleepEnd),
                    )
                  ],
                  // series: <ChartSeries>[
                  //   LineSeries<MoodRecord, int>(
                  //     sortingOrder: SortingOrder.descending,
                  //     sortFieldValueMapper: (MoodRecord mood, _) => mood.timestamp,
                  //     dataSource: _pageProvider.moodRecords,
                  //     yValueMapper: (MoodRecord mood, _) => _moodNames.indexOf(mood.mood.toString()),
                  //     xValueMapper: (MoodRecord mood, _) => mood.timestamp.day,
                  //     name: "Mood",
                  //     enableTooltip: true,
                  //     markerSettings: const MarkerSettings(isVisible: true),
                  //     yAxisName: "Day",
                  //   ),
                  // ],
                  primaryXAxis: CategoryAxis(
                    interval: 1,
                    title: AxisTitle(text: "Date"),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                  ),
                  primaryYAxis: NumericAxis(
                    isInversed: false,
                    interval: 1,
                    maximum: 12,
                    title: AxisTitle(text: "Hour"),

                    // axisLabelFormatter: (AxisLabelRenderDetails args) {
                    //   late num index = args.value;
                    //   late String text = kMoodEmojiList[index.toInt()];
                    //   late TextStyle textStyle;
                    //   textStyle = args.textStyle.copyWith(fontWeight: FontWeight.bold, fontSize: 22);
                    //   return ChartAxisLabel(text, textStyle);
                    // },
                  ),
                ),
              ),
            ),
          );
  }
}
