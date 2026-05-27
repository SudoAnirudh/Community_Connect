import 'package:flutter/material.dart';
import '../../../../core/mocks/mock_data.dart';
import '../widgets/community_post_card.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Community',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: false,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 100),
        itemCount: MockData.communityPosts.length,
        itemBuilder: (context, index) {
          return CommunityPostCard(post: MockData.communityPosts[index]);
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80), // Above nav bar
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
