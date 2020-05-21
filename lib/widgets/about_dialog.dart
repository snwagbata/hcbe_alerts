import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';


void showAboutDialog({
  @required BuildContext context,
}) {
  assert(context != null);
  showDialog<void>(
    context: context,
    builder: (context) {
      return _AboutDialog();
    },
  );
}

Future<String> getVersionNumber() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

class _AboutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final name = 'HCBE Alerts'; // Don't need to localize.
    final legalese = '©2020 Healersoft, Inc'; // Don't need to localize.

    return AlertDialog(
      content: Container(
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: getVersionNumber(),
              builder: (context, snapshot) => Text(
                snapshot.hasData ? '$name ${snapshot.data}' : '$name', style: Theme.of(context).textTheme.headline6,
              ),
            ),
            SizedBox(height: 24),
            Text(
              legalese,
            ),
          ],
        ),
      ),
      actions: [
        FlatButton(
          child: Text(
            'VIEW LICENSES',
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (context) => Theme(
                data: Theme.of(context).copyWith(
                  scaffoldBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: LicensePage(
                  applicationName: name,
                  applicationLegalese: legalese,
                ),
              ),
            ));
          },
        ),
        FlatButton(
          child: Text("CLOSE"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}