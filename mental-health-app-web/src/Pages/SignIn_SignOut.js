import { auth } from "../firebaseConfig";
import firebase from "firebase/app";

export default function SignIn() {
    const signInWithGoogle = () => {
        const provider = new firebase.auth.GoogleAuthProvider();
        auth.signInWithPopup(provider);
    };

    return (
        <button className="sign-in" onClick={signInWithGoogle}>
            Sign in with Google
        </button>
    );
}

export function SignOut() {
    return (
        auth.currentUser ? (
            <button className="sign-out" onClick={() => auth.signOut()}>
                Sign Out
            </button>
        ) : null
    );
}
