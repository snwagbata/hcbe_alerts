import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
//import axios from 'axios';

admin.initializeApp();

const fcm = admin.messaging();
//const db = admin.firestore();

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
 
export const sendTextNotif = functions.firestore
  .document('alerts/{alertId}')
  .onCreate(async (snapshot) => {
    //get schoolId
    const alert = snapshot.data();
    let alertType = alert?.alertType;
    let alertName;
    let schoolId = alert?.schoolId;
    let textAlertsUserNumbers: string[] = new Array();


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

    db.collection('users').where('schoolId', '==', schoolId).where('TextAlertsOptIn', '==', true).get()
      .then(snapshot => {
        if (snapshot.empty) {
          console.log('No matching documents.');
          return;
        }
        snapshot.forEach(doc => {
          let user = doc.data();
          let userPhoneNumber = user?.phoneNumber;
          textAlertsUserNumbers.push(userPhoneNumber);
        });
      })
      .catch(err => {
        console.log('Error getting documents', err);
      });

    /**
     * Will now iterate over the TextAlertsUserNumbers Array and 
     * send a text 
     *
    for (var i in textAlertsUserNumbers) {
      //Send number to textserver with message
      axios.post('https://textalerts.herokuapp.com/text', {
        phone: i,
        message: `${alertName} has been activated. Please follow the ${alertName} procedures.`,
      }).then(response => {
        console.log(response.data);
      })
    }

  });*/