import firebase from 'firebase/app';
import 'firebase/firestore';
import 'firebase/auth';

firebase.initializeApp({
    // Add config here
});

export const auth = firebase.auth();
export default firestore = firebase.firestore();