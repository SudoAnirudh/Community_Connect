import 'package:flutter/material.dart';
import '../../../../core/mocks/mock_data.dart';
import '../widgets/notice_card.dart';

class NoticesScreen extends StatelessWidget {
  const NoticesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notice Board',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
        itemCount: MockData.recentNotifications.length,
        itemBuilder: (context, index) {
          return NoticeCard(notice: MockData.recentNotifications[index]);
        },
      ),
    );
  }
}
