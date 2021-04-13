const functions = require("firebase-functions");
var admin = require("firebase-admin");

function userNotification(userID, chatData, from_name) {
  // console.log("i ran for user notification");

  admin
    .firestore()
    .collection("users")
    .doc(userID)
    .get()
    .then((snap) => {
      if (snap.exists) {
        admin.messaging().sendToDevice(
          snap.data().tokens, // ['token_1', 'token_2', ...]
          {
            notification: {
              title: `${from_name}`,
              body:
                chatData.message.length < 151
                  ? chatData.message
                  : String(chatData.message).substring(0, 151) + "...",
            },
          },
          {
            // Required for background/quit data-only messages on iOS
            contentAvailable: true,
            // Required for background/quit data-only messages on Android
            priority: "high",
          }
        );
      }
    });
}

exports.chats_notification = functions.firestore
  .document("/chats/{userID}")
  .onWrite((change, context) => {
    // const document = change.after.exists ? change.after.data() : null;
    // const newDocument = change.after.data();

    if (change.after.data().chats.length > 0) {
      let user_ids = [];
      user_ids = change.after.data().user_ids;
      let newChat = change.after.data().chats.pop();
      if (newChat.from !== undefined) {
        console.log("from defined");
        admin
          .firestore()
          .collection("users")
          .doc(newChat.from)
          .get()
          .then((snapshot) => {
            if (snapshot.exists) {
              user_ids.forEach((user_id) => {
                if (user_id !== newChat.from) {
                  userNotification(user_id, newChat, snapshot.data().full_name);
                }
              });
            }
          })
          .catch((error) => {
            console.log(error);
          });
      } else {
        // console.log('i returned');
      }
    }
  });
