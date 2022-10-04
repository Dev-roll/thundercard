import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:thundercard/api/current_brightness.dart';
import 'package:thundercard/api/return_original_color.dart';

import 'api/colors.dart';
import 'constants.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key, required this.room, required this.cardId});

  final types.Room room;
  final String cardId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _isAttachmentUploading = false;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness =
        currentBrightness(Theme.of(context).colorScheme);
    final ColorScheme myColorScheme = Theme.of(context).colorScheme;
    final ColorScheme partnerColorScheme = ThemeData.from(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Color(returnOriginalColor(widget.cardId)),
        brightness: brightness,
      ),
      useMaterial3: true,
    ).colorScheme;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            Theme.of(context).colorScheme.background.computeLuminance() < 0.5
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
        title: const Text('Chat'),
      ),
      body: StreamBuilder<types.Room>(
        initialData: widget.room,
        stream: FirebaseChatCore.instance.room(widget.room.id),
        builder: (context, snapshot) => StreamBuilder<List<types.Message>>(
          initialData: const [],
          stream: FirebaseChatCore.instance.messages(snapshot.data!),
          builder: (context, snapshot) => Chat(
            theme: DefaultChatTheme(
              // input
              inputTextColor: Theme.of(context).colorScheme.onSurfaceVariant,
              inputTextCursorColor: Theme.of(context).colorScheme.primary,
              inputBackgroundColor: alphaBlend(
                  Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  Theme.of(context).colorScheme.surface),
              // inputTextDecoration: ,
              // inputTextStyle: ,

              // sent
              primaryColor: myColorScheme.secondaryContainer,
              sentMessageDocumentIconColor: const Color(0xff000000),
              sentMessageBodyTextStyle: TextStyle(
                color: myColorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              sentMessageCaptionTextStyle: TextStyle(
                color: myColorScheme.onSecondaryContainer.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.333,
              ),
              sentMessageBodyLinkTextStyle: TextStyle(
                color: myColorScheme.onSecondaryContainer.withOpacity(0.7),
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
              sentMessageLinkTitleTextStyle: TextStyle(
                color: myColorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1.375,
              ),
              sentMessageLinkDescriptionTextStyle: TextStyle(
                color: myColorScheme.onSecondaryContainer.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.428,
              ),
              // sentMessageBodyBoldTextStyle: ,
              sentMessageBodyCodeTextStyle: GoogleFonts.robotoMono(
                textStyle: TextStyle(
                  backgroundColor: myColorScheme.background.withOpacity(0.5),
                  color: myColorScheme.onBackground.withOpacity(0.8),
                ),
              ),

              // received
              secondaryColor: partnerColorScheme.secondaryContainer,
              receivedMessageDocumentIconColor: const Color(0xff000000),
              receivedMessageBodyTextStyle: TextStyle(
                color: partnerColorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
              receivedMessageCaptionTextStyle: TextStyle(
                color: partnerColorScheme.onSecondaryContainer.withOpacity(0.6),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                height: 1.333,
              ),
              receivedMessageBodyLinkTextStyle: TextStyle(
                color: partnerColorScheme.onSecondaryContainer.withOpacity(0.7),
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
              receivedMessageLinkTitleTextStyle: TextStyle(
                color: partnerColorScheme.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
                height: 1.375,
              ),
              receivedMessageLinkDescriptionTextStyle: TextStyle(
                color: partnerColorScheme.onSecondaryContainer.withOpacity(0.6),
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.428,
              ),
              // receivedMessageBodyBoldTextStyle: ,
              receivedMessageBodyCodeTextStyle: GoogleFonts.robotoMono(
                textStyle: TextStyle(
                  backgroundColor:
                      partnerColorScheme.background.withOpacity(0.5),
                  color: partnerColorScheme.onBackground.withOpacity(0.8),
                ),
              ),

              // colors
              backgroundColor: Theme.of(context).colorScheme.background,
              errorColor: Theme.of(context).colorScheme.error,
              // userAvatarImageBackgroundColor: ,
              // userAvatarNameColors: ,

              // shape & space
              // inputBorderRadius:
              //     const BorderRadius.vertical(top: Radius.circular(20)),
              messageBorderRadius: 20,
              messageInsetsHorizontal: 18,
              messageInsetsVertical: 16,
              inputPadding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
              dateDividerMargin: const EdgeInsets.only(bottom: 12, top: 20),
              // statusIconPadding: ,
              // attachmentButtonMargin: ,
              // sendButtonMargin: ,
              // inputMargin: ,

              // text style
              dateDividerTextStyle: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  height: 1.333),
              emptyChatPlaceholderTextStyle: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant
                      .withOpacity(0.5),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  height: 1.5),
              // sentEmojiMessageTextStyle: ,
              // receivedEmojiMessageTextStyle: ,
              // userNameTextStyle: ,
              // userAvatarTextStyle: ,

              // icons
              attachmentButtonIcon: Icon(
                Icons.add_circle_outline_rounded,
                color: Theme.of(context).colorScheme.secondary,
              ),
              sendButtonIcon: Icon(
                Icons.send_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              documentIcon: Icon(
                Icons.description_rounded,
                color: white.withOpacity(0.8),
                // color: Theme.of(context)
                //     .colorScheme
                //     .onSecondaryContainer
                //     .withOpacity(0.75),
              ),
              // sendingIcon: Icon(
              //   Icons.pending_rounded,
              //   color: Theme.of(context).colorScheme.primary,
              //   size: 16,
              // ),
              // deliveredIcon: Icon(
              //   Icons.done_rounded,
              //   color: Theme.of(context).colorScheme.secondary,
              //   size: 16,
              // ),
              // seenIcon: Icon(
              //   Icons.done_all_rounded,
              //   color: Theme.of(context).colorScheme.secondary,
              //   size: 16,
              // ),
              // errorIcon: Icon(
              //   Icons.error_rounded,
              //   color: Theme.of(context).colorScheme.error,
              //   size: 16,
              // ),

              // other
              // inputContainerDecoration: ,
            ),
            isAttachmentUploading: _isAttachmentUploading,
            messages: snapshot.data ?? [],
            onAttachmentPressed: _handleAtachmentPressed,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            user: types.User(
              id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
            ),
          ),
        ),
      ),
    );
  }

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 200,
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: alphaBlend(
              Theme.of(context).colorScheme.primary.withOpacity(0.08),
              Theme.of(context).colorScheme.surface),
          boxShadow: [
            BoxShadow(
              color: alphaBlend(
                  Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  Theme.of(context).colorScheme.surface),
              offset: const Offset(0, -16),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleImageSelection();
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 32,
                    ),
                    Icon(
                      Icons.insert_photo_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Photo',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleFileSelection();
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 32,
                    ),
                    Icon(
                      Icons.source_rounded,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'File',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      _setAttachmentUploading(true);
      final name = result.files.single.name;
      final filePath = result.files.single.path!;
      final file = File(filePath);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(filePath),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final file = File(result.path);
      final size = file.lengthSync();
      final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);
      final name = result.name;

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: size,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          final updatedMessage = message.copyWith(isLoading: true);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );

          final client = http.Client();
          final request = await client.get(Uri.parse(message.uri));
          final bytes = request.bodyBytes;
          final documentsDir = (await getApplicationDocumentsDirectory()).path;
          localPath = '$documentsDir/${message.name}';

          if (!File(localPath).existsSync()) {
            final file = File(localPath);
            await file.writeAsBytes(bytes);
          }
        } finally {
          final updatedMessage = message.copyWith(isLoading: false);
          FirebaseChatCore.instance.updateMessage(
            updatedMessage,
            widget.room.id,
          );
        }
      }

      await OpenFile.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }
}
