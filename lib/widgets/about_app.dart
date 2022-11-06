import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../api/colors.dart';
import '../home_page.dart';

class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thundercardについて'),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(14.0, 0, 14.0, 0),
        child: const Markdown(data: '''
## 未来の名刺，全く新しいSNS。

Thundercardは名刺をヒントに開発された全く新しいSNSです。
SNSを使う若い世代，紹介したいプロフィールがたくさんあるエンジニアやクリエイターのみなさんに最適です。


### あなたのすべてを伝えます。

名前，勤務先，SNSや連絡先を登録するだけで，あなただけのカードを簡単に作成。もちろんお好みのデザインにカスタマイズできます。
Thundercardはすべての人に使いやすいアプリを目指して，他の名刺サービスよりたくさんのサービスに対応。
もし特殊なアカウントを登録したいときでも，お好きなリンクを追加できます。
登録した情報はいつでも好きなときに変更できます。


### 好きなときに好きなだけ情報を交換。

名刺の管理が面倒ですか？
Thundercardなら，他のSNSと同じような感覚で，簡単にカード交換ができます。
もちろん枚数制限はありません。名刺を忘れる心配は，もうないのです。
ビデオ会議などオンラインでのやりとりでは，URLや画像データの共有も便利です。


### ただの名刺アプリではありません，SNSです。

ワンタップでSNS・連絡先にアクセス，交換した相手との高機能なチャットも楽しめます。
カード交換後のつながりとチャンスも逃しません。
対面での出会いをオンラインでも継続させるこのアプリは，オフラインとオンラインとの橋渡しとして機能し，コロナ禍で失われた実際のつながりを取り戻すお手伝いをします。


### 電光石火のカード。

作ったカードを二次元バーコード，URL，画像で素早く交換。
他のSNSアプリの追随を許さない，高速・高性能なバーコード読み取り。
ストレスのない，世界最速のプロフィール交換を可能にします。


### アプリを使っていない人との名刺交換？Thundercardなら心配いりません。

Thundercardならアプリで作ったカードをボタン一つでエクスポートできるので，いざというときにも安心です。
もちろん，カメラを使って紙の名刺も追加できます。
写真を撮るだけで文字認識してくれるので入力する手間はありません。


### 人間中心の美しいUI。

ThundercardはGoogleが提唱するデザインシステム Material Design 3 に準拠。
ダークモードにも対応しています。

'''),
      ),
    );
  }
}
