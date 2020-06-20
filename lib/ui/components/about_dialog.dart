import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';


getVersionNumber() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

class AppAboutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = 'Safeskul'; // Don't need to localize.
    final legalese = '© 2020 Healersoft, Inc'; // Don't need to localize.
    final versionNum = getVersionNumber();

    return AlertDialog(
      content: Container(
        constraints: BoxConstraints(maxWidth: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            FutureBuilder(
              future: versionNum,
              builder: (context, snapshot) => Text(
                snapshot.hasData ? '$name ${snapshot.data}' : '$name',
                style: Theme.of(context).textTheme.headline6,
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
                  scaffoldBackgroundColor:
                      Theme.of(context).scaffoldBackgroundColor,
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
