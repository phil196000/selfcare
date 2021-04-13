const functions = require("firebase-functions");
var admin = require("firebase-admin");

//listen to collection
exports.tips_notification = functions.firestore
  .document("tips/{userID}")
  .onWrite((change, context) => {
    console.log("on write ran");
    // const document = change.after.exists ? change.after.data() : null;
    // const newDocument = change.after.data();
    const after = change.after.data();
    const before = change.before.data();
    if (after !== undefined) {
      const message = {
        data: {
          type: after.title,
          content:
            after.description.length < 151
              ? after.description
              : String(after.description).substring(0, 151) + "...",
        },
        topic: "tips",
      };

      admin
        .messaging()
        .sendToTopic("tips", {
          notification: {
            title: after.title,
            body:
              after.description.length < 151
                ? after.description
                : String(after.description).substring(0, 151) + "...",
          },
        })
        .then((response) => {
          console.log("Successfully sent message:", response);
        })
        .catch((error) => {
          console.log("Error sending message:", error);
        });
    } else {
      console.log("on write else ran");
    }
  });
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
