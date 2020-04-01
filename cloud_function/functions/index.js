const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.addUser = functions.https.onCall((data, context) => {
    const users = admin.firestore().collection('newUsers');
    return users.add({
        name: data["name"],
        email: data["email"],
        time: admin.firestore.FieldValue.serverTimestamp()
        ,

    });
});