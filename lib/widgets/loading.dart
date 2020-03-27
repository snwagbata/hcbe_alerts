import 'package:flutter/material.dart';

///
/// Wrap around any widget that makes an async call to show a modal progress
/// indicator while the async call is in progress.
///
/// The progress indicator can be turned on or off using [inAsyncCall]
class LoadingScreen extends StatelessWidget {
  final bool inAsyncCall;
  final Widget child;

  LoadingScreen({
    Key key,
    @required this.inAsyncCall,
    @required this.child,
  })  : assert(child != null),
        assert(inAsyncCall != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = [
        new Opacity(
          opacity: 0.75,
          child: ModalBarrier(
              dismissible: false, color: Theme.of(context).backgroundColor),
        ),
        new Center(
          child: new CircularProgressIndicator(),
        ),
      ];
      widgetList += modal;
    }
    return new Stack(
      children: widgetList,
    );
  }
}
