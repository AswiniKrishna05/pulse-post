const functions = require('firebase-functions');
const admin = require('firebase-admin');
const sgMail = require('@sendgrid/mail');

admin.initializeApp();
sgMail.setApiKey(functions.config().sendgrid.key);

exports.sendOtpForForgotPassword = functions.https.onCall(async (data) => {
  const email = data.email;
  if (!email) throw new functions.https.HttpsError('invalid-argument', 'Email is required');

  const otp = ('0000' + Math.floor(Math.random() * 10000)).slice(-4);
  const expiresAt = admin.firestore.Timestamp.fromDate(new Date(Date.now() + 10 * 60 * 1000));

  await admin.firestore().collection('passwordOtps').doc(email).set({
    otp,
    expiresAt
  });

  await sgMail.send({
    to: email,
    from: 'no-reply@yourapp.com',
    subject: 'Your Password Reset OTP',
    text: `Your OTP is ${otp}. It expires in 10 minutes.`,
  });

  return { success: true };
});
