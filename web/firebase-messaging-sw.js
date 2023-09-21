
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js');

   /*Update with yours config*/
  const firebaseConfig = {
    apiKey: 'AIzaSyCi5O8FnhURlZUnije7AwCtkjfqrPrY9C0',
    appId: '1:890229837369:web:850a04f81398135125c7e8',
    messagingSenderId: '890229837369',
    projectId: 'training-147f7',
    authDomain: 'training-147f7.firebaseapp.com',
    storageBucket: 'training-147f7.appspot.com',
    measurementId: 'G-HWTDMY57ML',
 };
  firebase.initializeApp(firebaseConfig);
  const messaging = firebase.messaging();

  /*messaging.onMessage((payload) => {
  console.log('Message received. ', payload);*/
  messaging.onBackgroundMessage(function(payload) {
    console.log('Received background message ', payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
      body: payload.notification.body,
    };

    self.registration.showNotification(notificationTitle,
      notificationOptions);
  });
