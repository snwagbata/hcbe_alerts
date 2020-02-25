import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const fcm = admin.messaging();

export const sendToTopic = functions.firestore
  .document('alerts/{alertId}')
  .onCreate(async (snapshot) => {
    const alert = snapshot.data();
    
    let alertType = alert?.alertType;
    let schoolId = alert?.schoolId;
    let alertName;

    switch (alertType) {
      case "red":
        alertName = "Code Red";
        break;

      case "yellow":
        alertName = "Code Yellow";
        break;

      case "blue":
        alertName = "Code Blue";
        break;

      case "intruder":
        alertName = "Active Intruder";
        break;

      default:
        alertName = "Code Green";
        break;

    }

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: alertName,
        body: `${alertName} has been activated.`,
        icon: '',
        click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
      }
    };

    return fcm.sendToTopic(schoolId, payload);
  });