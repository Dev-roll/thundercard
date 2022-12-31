import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

Future dynamicLinks(String cardId) async {
  final dynamicLinkParams = DynamicLinkParameters(
    link: Uri.parse('https://thundercard.gajeroll.com/?card_id=$cardId'),
    uriPrefix: 'https://thundercard.page.link',
    androidParameters: const AndroidParameters(
      packageName: 'app.web.thundercard',
      minimumVersion: 1,
    ),
    iosParameters: const IOSParameters(
      bundleId: 'app.web.thundercard',
      ipadBundleId: 'app.web.thundercard',
      appStoreId: '6444392874',
      minimumVersion: '1',
    ),
    navigationInfoParameters:
        const NavigationInfoParameters(forcedRedirectEnabled: true),
    // googleAnalyticsParameters: const GoogleAnalyticsParameters(
    //   source: 'twitter',
    //   medium: 'social',
    //   campaign: 'example-promo',
    // ),
    socialMetaTagParameters: SocialMetaTagParameters(
      title: '未来の名刺，全く新しいSNS。',
      description: 'SNSを使う若い世代，紹介したいプロフィールがたくさんあるエンジニアやクリエイターのみなさんに最適です。',
      imageUrl: Uri.parse(
          'https://user-images.githubusercontent.com/79978827/202828236-809fb30e-9d46-46aa-87da-18882e1f35b1.png'),
    ),
  );
  // final dynamicLink =
  //     await FirebaseDynamicLinks.instance.buildShortLink(dynamicLinkParams);
  final unguessableDynamicLink =
      await FirebaseDynamicLinks.instance.buildShortLink(
    dynamicLinkParams,
    shortLinkType: ShortDynamicLinkType.unguessable,
  );
  return unguessableDynamicLink;
}
