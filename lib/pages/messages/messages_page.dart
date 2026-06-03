import 'package:flutter/material.dart';

import '../../const/app_const.dart';
import '../../utils/app_navigator.dart';
import '../home/home_models.dart';
import 'chat_detail_page.dart';
import 'messages_models.dart';

/// Messages tab — conversation list matching the Figma reference. Static mock
/// data ([MessagesMockData]); the bottom nav is owned by [MainShell].
class MessagesPage extends StatelessWidget {
  const MessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  Text('Messages', style: AppConst.t1.copyWith(fontSize: 24)),
                  const Spacer(),
                  Text(
                    'New message',
                    style: AppConst.body.copyWith(
                      color: AppConst.accent,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.5,
                    ),
                  ),
                ],
              ),
            ),
            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppConst.gray.withOpacity(0.7)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded,
                        size: 22, color: AppConst.appBlack),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: AppConst.body.copyWith(fontSize: 14),
                        decoration: InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          hintText: 'Search',
                          hintStyle: AppConst.body.copyWith(
                            color: AppConst.darkGray,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppConst.lightGray),
            // Conversations
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                physics: AppConst.scrollPhysics,
                itemCount: MessagesMockData.conversations.length,
                itemBuilder: (context, i) {
                  final c = MessagesMockData.conversations[i];
                  return GestureDetector(
                    onTap: () => AppNavigator.navigateTo(
                      context,
                      ChatDetailPage(conversation: c),
                    ),
                    behavior: HitTestBehavior.opaque,
                    child: _ConversationTile(c: c),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final Conversation c;

  const _ConversationTile({required this.c});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConst.radius),
        border: Border.all(color: AppConst.gray.withOpacity(0.5)),
        boxShadow: const [AppConst.softShadow],
      ),
      child: Row(
        children: [
          _Avatar(name: c.name, seed: c.seed),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name,
                  style: AppConst.body.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppConst.appBlack,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    if (c.sentCheck) ...[
                      const Icon(Icons.check,
                          size: 14, color: AppConst.darkGray),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        c.lastMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppConst.caption.copyWith(
                          fontSize: 13,
                          color: AppConst.darkGray,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (c.unread > 0) ...[
            const SizedBox(width: 10),
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppConst.primary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${c.unread}',
                style: AppConst.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String name;
  final int seed;

  const _Avatar({required this.name, required this.seed});

  @override
  Widget build(BuildContext context) {
    final colors = HomeMockData.placeholderGradient(seed);
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        name.isNotEmpty ? name.substring(0, 1) : '?',
        style: AppConst.t2.copyWith(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
