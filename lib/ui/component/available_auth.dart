import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AvailableAuth extends StatefulWidget {
  const AvailableAuth({super.key});

  @override
  AvailableAuthState createState() => AvailableAuthState();
}

class AvailableAuthState extends State<AvailableAuth> {
  List<String> authProviders = [];
  List<String> allProviders = ['password', 'google.com', 'apple.com'];

  @override
  void initState() {
    super.initState();
    getUserAuthProviders();
  }

  Future<void> getUserAuthProviders() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      authProviders = user.providerData
          .map((userInfo) => userInfo.providerId.toString())
          .toList();
    }
    setState(() {});
  }

  String getProviderName(String providerId) {
    switch (providerId) {
      case 'password':
        return 'パスワード';
      case 'google.com':
        return 'Google';
      case 'apple.com':
        return 'Apple';
      // Add more cases for other providers if needed
      default:
        return providerId;
    }
  }

  IconData getProviderIcon(String providerId) {
    switch (providerId) {
      case 'password':
        return Icons.password_rounded;
      case 'google.com':
        return FontAwesomeIcons.google;
      case 'apple.com':
        return Icons.apple;
      default:
        return Icons.lock_outline_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return authProviders.isEmpty
        ? Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 14),
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.errorContainer.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ログイン情報が登録されていません。',
                  style: TextStyle(
                    height: 1.6,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
                const Text(
                  'ログイン機能を利用するには以下のボタンから認証方法を追加してください。',
                  style: TextStyle(height: 1.8),
                ),
              ],
            ),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('連携済みの認証方法'),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: allProviders.map(
                    (providerId) {
                      String providerName = getProviderName(providerId);
                      IconData providerIcon = getProviderIcon(providerId);
                      bool isAuthorized =
                          authProviders.contains(providerId); // 認証されているかどうかを確認

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          height: 40, // 固定の高さを指定
                          padding: const EdgeInsets.fromLTRB(8, 0, 14, 2),
                          decoration: BoxDecoration(
                            color: isAuthorized
                                ? null
                                : Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant
                                    .withOpacity(0.4), // 認証されていない場合はグレーアウト
                            border: isAuthorized
                                ? Border.all(
                                    style: BorderStyle.solid,
                                    width: 1,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  )
                                : null,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              if (providerId != 'apple.com')
                                const SizedBox(width: 4),
                              Icon(
                                providerIcon,
                                color: isAuthorized
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withOpacity(0.4), // 認証されていない場合はグレーアウト
                                size: providerId == 'apple.com' ? 26 : 22,
                              ),
                              if (providerId != 'apple.com')
                                const SizedBox(width: 4),
                              const SizedBox(width: 4),
                              Text(
                                providerName,
                                style: TextStyle(
                                  color: isAuthorized
                                      ? Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withOpacity(
                                            0.4,
                                          ), // 認証されていない場合はグレーアウト
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          );
  }
}
