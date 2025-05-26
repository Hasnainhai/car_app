import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/constant.dart';

class CustomRangeSlider extends StatefulWidget {
  final double min;
  final double max;
  final double startValue;
  final double endValue;
  final Function(RangeValues) onChange;

  final int divisions;

  const CustomRangeSlider({
    Key? key,
    required this.min,
    required this.max,
    required this.startValue,
    required this.endValue,

    required this.onChange,
    this.divisions = 1,
  }) : super(key: key);

  @override
  _CustomRangeSliderState createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  late double _startValue;
  late double _endValue;
  final formatter = NumberFormat("#,###", "en_US");

  @override
  void initState() {
    _startValue = widget.startValue;
    _endValue = widget.endValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        showValueIndicator: ShowValueIndicator.always, // Always show value indicator
        trackHeight: 2.0,
        activeTrackColor: primaryColor,
        inactiveTrackColor: colorE6,
        trackShape: const RoundedRectSliderTrackShape(),
        thumbColor: primaryColor,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 10.0,
          elevation: 2.0,
          pressedElevation: 4.0,
        ),
        overlayColor: primaryColor.withOpacity(0.2),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14.0),
        inactiveTickMarkColor: Colors.transparent,
        activeTickMarkColor: Colors.transparent,
      ),
      child: RangeSlider(
        values: RangeValues(_startValue, _endValue),
        min: widget.min,
        max: widget.max,
        divisions: widget.divisions,
        onChanged: (values) {
          setState(() {
            _startValue = values.start;
            _endValue = values.end;
          });
         widget.onChange(values);
        },
        
      ),
    );
  }
}
