import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const fcm = admin.messaging();
const db = admin.firestore();

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

/**
 * Will get the school id of a school where an alert in triggered and send
 * an alert to users who have opted in to receiving text alerts from the school
 */
export const sendTextNotif = functions.firestore
  .document('alerts/{alertId}')
  .onCreate(async (snapshot) => {
    //get schoolId
    const alert = snapshot.data();
    let schoolId = alert?.schoolId;
    let TextAlertsUserNumbers: number[];


    db.collection('users').where('schoolId', '==', schoolId).where('TextAlertsOptIn', '==', true).get()
      .then(snapshot => {
        if (snapshot.empty) {
          console.log('No matching documents.');
          return;
        }
        snapshot.forEach(doc => {
          TextAlertsUserNumbers.push
          console.log(doc.id, '=>', doc.data());
        });
      })
      .catch(err => {
        console.log('Error getting documents', err);
      });

  });