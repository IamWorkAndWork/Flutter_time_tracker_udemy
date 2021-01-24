import 'package:flutter/material.dart';

enum TabItem { jobs, entries, account }

class TabItemData {
  final String title;
  final Icon icon;

  const TabItemData({@required this.title, @required this.icon});

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(title: "Jobs", icon: Icon(Icons.work)),
    TabItem.entries:
        TabItemData(title: "Entries", icon: Icon(Icons.view_headline)),
    TabItem.account: TabItemData(title: "Account", icon: Icon(Icons.person)),
  };
}
