import 'package:flutter/material.dart';

import '../../../curbo_mobile_utils.dart';

class CustomRangeSlider extends StatefulWidget {
  CustomRangeSlider({
    Key? key,
    required this.minValue,
    required this.maxValue,
    required this.startValue,
    required this.endValue,
    this.title = "Range",
    this.from = "From",
    this.to = "To",
    this.inputRedonly = false,
    this.onChanged,
    this.dividerCounter = 1,
    this.textInputFormatter,
    this.formatLabel,
    this.scrollController,
  }) : super(key: key);

  final String title;
  final String from;
  final String to;
  final double minValue;
  final double maxValue;
  final double startValue;
  final double endValue;
  final bool inputRedonly;
  final int dividerCounter;
  final Function(RangeValues)? onChanged;
  final NumericTextFormatter? textInputFormatter;
  final Function(num)? formatLabel;
  final ScrollController? scrollController;

  @override
  _CustomRangeSliderState createState() => _CustomRangeSliderState();
}

class _CustomRangeSliderState extends State<CustomRangeSlider> {
  final _startFocus = FocusNode();
  final _endFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  final _startController = TextEditingController();
  final _endController = TextEditingController();

  late double _startValue;
  late double _endValue;
  late int _divisionds;

  @override
  void initState() {
    super.initState();

    _divisionds = _calculateDivisions();

    _startValue = widget.startValue;
    _endValue = widget.endValue;

    final formatter = widget.textInputFormatter?.formatter;

    _startController.text = formatter == null
        ? _startValue.toInt().toString()
        : formatter.format(_startValue.toInt());
    _endController.text = formatter == null
        ? _endValue.toInt().toString()
        : formatter.format(_endValue.toInt());

    _startController.addListener(_setStartValue);
    _endController.addListener(_setEndValue);
  }

  @override
  void dispose() {
    _startFocus.dispose();
    _endFocus.dispose();

    _startController.dispose();
    _endController.dispose();

    super.dispose();
  }

  void _setStartValue() {
    final start = _startController.text.replaceAll(",", "");

    _setValue(() {
      _startValue = double.parse(start.isEmpty ? "0" : start).roundToDouble();

      if (widget.onChanged != null)
        widget.onChanged!(
          RangeValues(_startValue, _endValue),
        );
    });
  }

  void _setEndValue() {
    final end = _endController.text.replaceAll(",", "");

    _setValue(() {
      _endValue = double.parse(end.isEmpty ? "0" : end).roundToDouble();

      if (widget.onChanged != null)
        widget.onChanged!(
          RangeValues(_startValue, _endValue),
        );
    });
  }

  void _setValue(Function doAction) {
    final start = _startController.text.replaceAll(",", "");
    final end = _endController.text.replaceAll(",", "");

    _formKey.currentState?.validate();

    final startParsed =
        double.parse(start.isEmpty ? "0" : start).roundToDouble();
    final endParsed = double.parse(end.isEmpty ? "0" : end).roundToDouble();

    if (startParsed <= endParsed &&
        startParsed >= widget.minValue &&
        endParsed >= widget.minValue &&
        startParsed <= widget.maxValue &&
        endParsed <= widget.maxValue) {
      setState(() {
        doAction();
      });
    }
  }

  void _onChanged(RangeValues values) {
    _setValues(values);
  }

  void _setValues(RangeValues values) {
    final formatter = widget.textInputFormatter?.formatter;

    setState(() {
      _startValue = values.start.roundToDouble();
      _endValue = values.end.roundToDouble();
      _startController.text = formatter == null
          ? values.start.toInt().toString()
          : formatter.format(values.start.toInt());
      _endController.text = formatter == null
          ? values.end.toInt().toString()
          : formatter.format(values.end.toInt());

      if (widget.onChanged != null) widget.onChanged!(values);
    });
  }

  int _calculateDivisions() {
    final total = widget.maxValue - widget.minValue;
    return total ~/ widget.dividerCounter;
  }

  void _moveScroll(bool moveUp) {
    if (widget.scrollController == null) return;

    Future.delayed(Duration(milliseconds: moveUp ? 350 : 150), () {
      widget.scrollController?.animateTo(
        widget.scrollController!.position.pixels + (moveUp ? 60 : -60),
        duration: Duration(milliseconds: 250),
        curve: Curves.fastOutSlowIn,
      );
    });
  }

  void _evaluateBounds(TextEditingController controller) {
    final value = controller.text.replaceAll(",", "");
    final valueParsed = double.parse(value.isEmpty ? "0" : value);

    final formatter = widget.textInputFormatter?.formatter;

    if (valueParsed <= widget.minValue) {
      controller.text = formatter == null
          ? widget.minValue.toInt().toString()
          : formatter.format(widget.minValue.toInt());
    } else if (valueParsed > widget.maxValue) {
      controller.text = formatter == null
          ? widget.maxValue.toInt().toString()
          : formatter.format(widget.maxValue.toInt());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _buildInput(context),
          _buildRangeSlider(context),
          _buildLabels(context),
        ],
      ),
    );
  }

  Widget _buildInput(BuildContext context) {
    return KeyboardDoneAction(
      platform: PlatfromSupport.ios,
      focusNodes: <FocusNode>[
        _startFocus,
        _endFocus,
      ],
      onShow: () => _moveScroll(true),
      onHide: () => _moveScroll(false),
      onDone: () {
        _evaluateBounds(_startController);
        _evaluateBounds(_endController);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Flexible(
            flex: 2,
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Spaces.horizontalLarge(),
          Flexible(
            flex: 4,
            child: TextFormField(
              readOnly: widget.inputRedonly,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 12.0),
              controller: _startController,
              focusNode: _startFocus,
              onFieldSubmitted: (_) {
                _evaluateBounds(_startController);
                _evaluateBounds(_endController);
              },
              textInputAction: TextInputAction.done,
              inputFormatters: widget.textInputFormatter == null
                  ? null
                  : [widget.textInputFormatter!],
              decoration: InputDecoration(
                labelText: widget.from,
                errorStyle: TextStyle(height: 0),
              ),
            ),
          ),
          Spaces.horizontalLarge(),
          Flexible(
            flex: 4,
            child: TextFormField(
              readOnly: widget.inputRedonly,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 12.0),
              controller: _endController,
              focusNode: _endFocus,
              onFieldSubmitted: (_) {
                _evaluateBounds(_startController);
                _evaluateBounds(_endController);
              },
              textInputAction: TextInputAction.done,
              inputFormatters: widget.textInputFormatter == null
                  ? null
                  : [widget.textInputFormatter!],
              decoration: InputDecoration(
                labelText: widget.to,
                errorStyle: TextStyle(height: 0),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangeSlider(BuildContext context) {
    return RangeSlider(
      values: RangeValues(_startValue, _endValue),
      min: widget.minValue,
      max: widget.maxValue,
      divisions: _divisionds,
      onChanged: _onChanged,
    );
  }

  Widget _buildLabels(BuildContext context) {
    final start = widget.formatLabel == null
        ? '${_startValue.toInt()}'
        : widget.formatLabel!(_startValue);

    final end = widget.formatLabel == null
        ? '${_endValue.toInt()}'
        : widget.formatLabel!(_endValue);

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(start),
          Text(end),
        ],
      ),
    );
  }
}
