import firebase from 'firebase/app';
import 'firebase/firestore';
import 'firebase/auth';

firebase.initializeApp({
    // Add config here
    apiKey: "AIzaSyBvuhOtC73r5cFvVralc_K4JQNOOsoV40Q",
    authDomain: "mental-health-app-e2112.firebaseapp.com",
    projectId: "mental-health-app-e2112",
    storageBucket: "mental-health-app-e2112.appspot.com",
    messagingSenderId: "853014821948",
    appId: "1:853014821948:web:824fe17da40b19646bd739",
    measurementId: "G-K4WSJ64G2Y"
});
firebase.analytics();
export const auth = firebase.auth();
export default firestore = firebase.firestore();
