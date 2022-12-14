const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

admin.initializeApp();

exports.helloWorld = functions.https.onRequest((request, response) => {
  response.send("Hello from Firebase!");
});

exports.changeMessageStatus = functions.firestore
  .document("rooms/{roomId}/messages/{messageId}")
  .onWrite((change) => {
    const message = change.after.data();
    if (message) {
      if (["delivered", "seen", "sent"].includes(message.status)) {
        return null;
      } else {
        return change.after.ref.update({
          status: "delivered",
        });
      }
    } else {
      return null;
    }
  });

  exports.deleteUser = functions
    .region("asia-northeast1")
    .firestore.document("deleted_users/{docId}")
    .onCreate(async (snap, context) => {
      const deleteDocument = snap.data();
      const uid = deleteDocument.uid;

      // Authenticationのユーザーを削除する
      await admin.auth().deleteUser(uid);
    });

// admin.initializeApp();

// const db = admin.firestore();

// exports.changeLastMessage = functions.firestore
//   .document("rooms/{roomId}/messages/{messageId}")
//   .onWrite((change, context) => {
//     const message = change.after.data();
//     if (message) {
//       return db.doc("rooms/" + context.params.roomId).update({
//         lastMessages: [message],
//       });
//     } else {
//       return null;
//     }
//   });
