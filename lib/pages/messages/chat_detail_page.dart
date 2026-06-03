import 'package:flutter/material.dart';

import '../../const/app_const.dart';
import '../home/home_models.dart';
import 'messages_models.dart';

/// Chat detail — opened by tapping a conversation in [MessagesPage].
///
/// Outgoing messages are orange right-aligned bubbles; incoming messages are
/// plain left-aligned text (matching the Figma reference). Static mock thread.
class ChatDetailPage extends StatefulWidget {
  final Conversation conversation;

  const ChatDetailPage({super.key, required this.conversation});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  static const _languages = [
    'English',
    'French',
    'Arabic',
    'Spanish',
    'Hindi',
    'German',
  ];

  bool _translate = false;
  String _myLang = 'French';
  String _otherLang = 'Arabic';

  Future<void> _pickLanguage({required bool isMine}) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: AppConst.gray,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 10),
            for (final l in _languages)
              ListTile(
                title: Text(l, style: AppConst.body.copyWith(fontSize: 15)),
                trailing: (isMine ? _myLang : _otherLang) == l
                    ? const Icon(Icons.check_rounded, color: AppConst.primary)
                    : null,
                onTap: () => Navigator.pop(ctx, l),
              ),
          ],
        ),
      ),
    );
    if (selected == null) return;
    setState(() {
      if (isMine) {
        _myLang = selected;
      } else {
        _otherLang = selected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversation = widget.conversation;
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const _MessageInputBar(),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 14, 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    behavior: HitTestBehavior.opaque,
                    child: const Icon(Icons.chevron_left_rounded,
                        size: 28, color: AppConst.appBlack),
                  ),
                  const SizedBox(width: 6),
                  _Avatar(name: conversation.name, seed: conversation.seed),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      conversation.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppConst.t2.copyWith(fontSize: 18),
                    ),
                  ),
                  // Translation toggle — orange when active, grey when off.
                  GestureDetector(
                    onTap: () => setState(() => _translate = !_translate),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _translate
                            ? AppConst.primary.withOpacity(0.12)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.translate_rounded,
                        size: 22,
                        color: _translate
                            ? AppConst.primary
                            : AppConst.darkGray,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: AppConst.lightGray),
            // Translation language bar (only when toggled on).
            AnimatedSize(
              duration: AppConst.animationDuration,
              curve: AppConst.curves,
              child: _translate
                  ? _TranslationBar(
                      myLang: _myLang,
                      otherLang: _otherLang,
                      onPickMine: () => _pickLanguage(isMine: true),
                      onPickOther: () => _pickLanguage(isMine: false),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            // Thread
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
                physics: AppConst.scrollPhysics,
                children: [
                  for (final m in MessagesMockData.thread) _Bubble(message: m),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "Me [lang] ⇄ Other Person [lang]" translation selector — orange outlined.
class _TranslationBar extends StatelessWidget {
  final String myLang;
  final String otherLang;
  final VoidCallback onPickMine;
  final VoidCallback onPickOther;

  const _TranslationBar({
    required this.myLang,
    required this.otherLang,
    required this.onPickMine,
    required this.onPickOther,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConst.primary, width: 1.4),
      ),
      child: Row(
        children: [
          Expanded(
            child: _LangCell(label: 'Me', lang: myLang, onTap: onPickMine),
          ),
          const Icon(Icons.swap_horiz_rounded,
              size: 22, color: AppConst.appBlack),
          Expanded(
            child: _LangCell(
                label: 'Other Person', lang: otherLang, onTap: onPickOther),
          ),
        ],
      ),
    );
  }
}

class _LangCell extends StatelessWidget {
  final String label;
  final String lang;
  final VoidCallback onTap;

  const _LangCell({
    required this.label,
    required this.lang,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: AppConst.caption
                  .copyWith(color: AppConst.darkGray, fontSize: 12)),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(lang,
                  style: AppConst.body.copyWith(
                      color: AppConst.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15)),
              const Icon(Icons.keyboard_arrow_down_rounded,
                  size: 18, color: AppConst.primary),
            ],
          ),
        ],
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final ChatMessage message;

  const _Bubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width * 0.72;

    if (!message.isMe) {
      // Incoming — plain left-aligned grey text, no bubble.
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxW),
            child: Text(
              message.text,
              style: AppConst.body.copyWith(
                fontSize: 14.5,
                color: AppConst.darkGray,
                height: 1.4,
              ),
            ),
          ),
        ),
      );
    }

    // Outgoing — orange bubble, right-aligned.
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxW),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppConst.primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              message.text,
              style: AppConst.body.copyWith(
                color: Colors.white,
                fontSize: 14.5,
                height: 1.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MessageInputBar extends StatelessWidget {
  const _MessageInputBar();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppConst.gray.withOpacity(0.7)),
          ),
          child: Row(
            children: [
              const Icon(Icons.emoji_emotions_outlined,
                  color: AppConst.warning, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  style: AppConst.body.copyWith(fontSize: 14),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Type message',
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
      width: 40,
      height: 40,
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
        style: AppConst.body.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
    );
  }
}
