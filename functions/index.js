const functions = require("firebase-functions");
var admin = require("firebase-admin");
var serviceAccount = require("./selfcare-43f41-firebase-adminsdk-kk3co-b0991e639a.json");
const { tips_notification } = require("./EndPoints/TipsNotification");
const { chats_notification } = require("./EndPoints/ChatNotification");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://smartixeducation-c1183.firebaseio.com",
});
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
exports.tips_notification = tips_notification;
exports.chats_notification = chats_notification;
