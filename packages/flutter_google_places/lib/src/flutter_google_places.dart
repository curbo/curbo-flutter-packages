library flutter_google_places.src;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';

class PlacesAutocompleteWidget extends StatefulWidget {
  final String apiKey;
  final String? startText;
  final TextStyle? textStyle;
  final BoxDecoration? decoration;
  final String cancel;
  final String hint;
  final BorderRadius? overlayBorderRadius;
  final Location? location;
  final num? offset;
  final num? radius;
  final String? language;
  final String? sessionToken;
  final List<String>? types;
  final List<Component>? components;
  final bool? strictbounds;
  final String? region;
  final ValueChanged<PlacesAutocompleteResponse>? onError;
  final int debounce;

  /// optional - sets 'proxy' value in google_maps_webservice
  ///
  /// In case of using a proxy the baseUrl can be set.
  /// The apiKey is not required in case the proxy sets it.
  /// (Not storing the apiKey in the app is good practice)
  final String? proxyBaseUrl;

  /// optional - set 'client' value in google_maps_webservice
  ///
  /// In case of using a proxy url that requires authentication
  /// or custom configuration
  final BaseClient? httpClient;

  const PlacesAutocompleteWidget(
      {required this.apiKey,
      this.hint = "Search",
      this.cancel = "Cancel",
      this.textStyle,
      this.decoration,
      this.overlayBorderRadius,
      this.offset,
      this.location,
      this.radius,
      this.language,
      this.sessionToken,
      this.types,
      this.components,
      this.strictbounds,
      this.region,
      this.onError,
      Key? key,
      this.proxyBaseUrl,
      this.httpClient,
      this.startText,
      this.debounce = 300})
      : super(key: key);

  @override
  State<PlacesAutocompleteWidget> createState() =>
      _PlacesAutocompleteScaffoldState();

  static PlacesAutocompleteState? of(BuildContext context) =>
      context.findAncestorStateOfType<PlacesAutocompleteState>();
}

class _PlacesAutocompleteScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          AppBarPlacesAutoCompleteTextField(
            decoration: widget.decoration,
            searchBarHint: widget.hint,
            cancel: widget.cancel,
            textStyle: widget.textStyle,
          ),
          Expanded(
            child: PlacesAutocompleteResult(
              onTap: Navigator.of(context).pop,
            ),
          ),
        ],
      ),
    );
  }
}

class _Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(maxHeight: 4.0),
        child: const LinearProgressIndicator());
  }
}

class PlacesAutocompleteResult extends StatefulWidget {
  final ValueChanged<Prediction>? onTap;
  final Widget? logo;

  const PlacesAutocompleteResult({Key? key, this.onTap, this.logo})
      : super(key: key);

  @override
  _PlacesAutocompleteResult createState() => _PlacesAutocompleteResult();
}

class _PlacesAutocompleteResult extends State<PlacesAutocompleteResult> {
  @override
  Widget build(BuildContext context) {
    final state = PlacesAutocompleteWidget.of(context)!;

    if (state._queryTextController!.text.isEmpty ||
        state._response == null ||
        state._response!.predictions.isEmpty) {
      final children = <Widget>[];
      if (state._searching) {
        children.add(_Loader());
      }

      return Stack(children: children);
    }
    return PredictionsListView(
      predictions: state._response!.predictions,
      onTap: widget.onTap,
    );
  }
}

class AppBarPlacesAutoCompleteTextField extends StatefulWidget {
  final BoxDecoration? decoration;
  final TextStyle? textStyle;
  final String? searchBarHint;
  final String? cancel;

  const AppBarPlacesAutoCompleteTextField({
    Key? key,
    this.decoration,
    this.textStyle,
    this.searchBarHint,
    this.cancel,
  }) : super(key: key);

  @override
  _AppBarPlacesAutoCompleteTextFieldState createState() =>
      _AppBarPlacesAutoCompleteTextFieldState(
        decoration: decoration,
        textStyle: textStyle,
        searchBarHint: searchBarHint,
        cancel: cancel,
      );
}

class _AppBarPlacesAutoCompleteTextFieldState
    extends State<AppBarPlacesAutoCompleteTextField> {
  _AppBarPlacesAutoCompleteTextFieldState({
    required this.decoration,
    required this.searchBarHint,
    required this.cancel,
    this.textStyle,
  });

  final BoxDecoration? decoration;
  final TextStyle? textStyle;
  final String? searchBarHint;
  final String? cancel;

  @override
  Widget build(BuildContext context) {
    final state = PlacesAutocompleteWidget.of(context)!;

    return _buildHeaderSection(state);
  }

  Widget _buildHeaderSection(PlacesAutocompleteState state) {
    return Container(
      height: 120.0,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Container(decoration: decoration),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              padding: const EdgeInsets.only(
                top: 16.0,
                bottom: 16.0,
                left: 16.0,
                right: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: _buildSearchInput(state),
                  ),
                  _buildCancelButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInput(PlacesAutocompleteState state) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6.0)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              autofocus: true,
              textInputAction: TextInputAction.search,
              controller: state._queryTextController,
              style: textStyle ??
                  const TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.black54,
                  ),
              decoration: InputDecoration(
                hintText: searchBarHint,
                contentPadding: const EdgeInsets.all(16.0),
                prefixIcon: const Icon(
                  Icons.search,
                ),
                border: InputBorder.none,
              ),
              onSubmitted: (value) => state.doSearch(value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancelButton() {
    return TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        cancel!,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class PredictionsListView extends StatelessWidget {
  final List<Prediction> predictions;
  final ValueChanged<Prediction>? onTap;

  const PredictionsListView({Key? key, required this.predictions, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: predictions.length,
      itemBuilder: (context, index) {
        final p = predictions[index];

        return PredictionTile(prediction: p, onTap: onTap);
      },
      separatorBuilder: (_, __) => const Divider(),
    );
  }
}

class PredictionTile extends StatelessWidget {
  final Prediction prediction;
  final ValueChanged<Prediction>? onTap;

  const PredictionTile({Key? key, required this.prediction, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      leading: const Icon(Icons.location_on),
      title: Text(prediction.description!),
      onTap: () {
        if (onTap != null) {
          onTap!(prediction);
        }
      },
    );
  }
}

abstract class PlacesAutocompleteState extends State<PlacesAutocompleteWidget> {
  TextEditingController? _queryTextController;
  PlacesAutocompleteResponse? _response;
  GoogleMapsPlaces? _places;
  late bool _searching;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _queryTextController = TextEditingController(text: widget.startText);

    _initPlaces();
    _searching = false;
  }

  Future<Null> doSearch(String value) async {
    if (mounted && value.isNotEmpty && _places != null) {
      setState(() {
        _searching = true;
      });

      final res = await _places!.autocomplete(
        value,
        offset: widget.offset,
        location: widget.location,
        radius: widget.radius,
        language: widget.language,
        sessionToken: widget.sessionToken,
        types: widget.types ?? [],
        components: widget.components ?? [],
        strictbounds: widget.strictbounds ?? false,
        region: widget.region,
      );

      if (res.errorMessage?.isNotEmpty == true ||
          res.status == "REQUEST_DENIED") {
        onResponseError(res);
      } else {
        onResponse(res);
      }
    } else {
      onResponse(null);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _places?.dispose();
    _debounce?.cancel();
  }

  @mustCallSuper
  void onResponseError(PlacesAutocompleteResponse res) {
    if (!mounted) return;

    if (widget.onError != null) {
      widget.onError!(res);
    }
    setState(() {
      _response = null;
      _searching = false;
    });
  }

  @mustCallSuper
  void onResponse(PlacesAutocompleteResponse? res) {
    if (!mounted) return;

    setState(() {
      _response = res;
      _searching = false;
    });
  }

  Future<void> _initPlaces() async {
    _places = GoogleMapsPlaces(
      apiKey: widget.apiKey,
      baseUrl: widget.proxyBaseUrl,
      httpClient: widget.httpClient,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
  }
}

class PlacesAutocomplete {
  static Future<Prediction?> show(
      {required BuildContext context,
      required String apiKey,
      String hint = "Search",
      BorderRadius? overlayBorderRadius,
      num? offset,
      Location? location,
      num? radius,
      String? language,
      String? sessionToken,
      List<String>? types,
      List<Component>? components,
      bool? strictbounds,
      String? region,
      Widget? logo,
      ValueChanged<PlacesAutocompleteResponse>? onError,
      String? proxyBaseUrl,
      Client? httpClient,
      String startText = ""}) {
    final builder = (BuildContext ctx) => PlacesAutocompleteWidget(
          apiKey: apiKey,
          overlayBorderRadius: overlayBorderRadius,
          language: language,
          sessionToken: sessionToken,
          components: components,
          types: types,
          location: location,
          radius: radius,
          strictbounds: strictbounds,
          region: region,
          offset: offset,
          hint: hint,
          onError: onError,
          proxyBaseUrl: proxyBaseUrl,
          httpClient: httpClient as BaseClient?,
          startText: startText,
        );

    return Navigator.push(context, MaterialPageRoute(builder: builder));
  }
}
