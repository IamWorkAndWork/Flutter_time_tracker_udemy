import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key key}) : super(key: key);

  Future<void> _signout(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: "Logout",
        content: "Are you sure you want to logouy?",
        defaultActionText: "Logout",
        cancelActionText: "Cancel");
    if (didRequestSignOut) {
      _signout(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return Container(
        child: Scaffold(
      appBar: AppBar(
        title: Text("Account"),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _confirmSignOut(context),
            child: Text(
              "Log out",
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: Container(),
    ));
  }
}
