import firestore,{ auth } from "../../firebaseConfig";
import firebase from "firebase/app";
import { useContext } from "react";
import UserContext from "../../Context/UserContext";

export default function SignIn() {
    const {setUser} = useContext(UserContext);
    const usersRef = firestore.collection('users');

    const signInWithGoogle = async () => {
        try {
            const provider = new firebase.auth.GoogleAuthProvider();
            const user = await auth.signInWithPopup(provider).then(res => res.user);
            const snapshot = await usersRef.doc(user.uid).get();
            if(!snapshot.exists){
                const newUser = {
                    email: user.email,
                    name: user.displayName,
                    contentCreator: false,
                    photoURL: user.photoURL,
                    admin: false
                }
                usersRef.doc(user.uid).set(newUser);
                setUser({uid: user.uid, ...newUser});
            } else {
                setUser({uid: user.uid, ...snapshot.data()});
            }
        } catch (error) {
            console.error("Error:", error)
        }
    };

    return (
        <button className="sign-in" onClick={signInWithGoogle}>
            Sign in with Google
        </button>
    );
}

export function SignOut() {
    const {setUser} = useContext(UserContext);
    const signOutUser = () => {
        auth.signOut().then(() => setUser(null));
    }
    return (
        auth.currentUser ? (
            <button className="sign-out" onClick={signOutUser}>
                Sign Out
            </button>
        ) : null
    );
}
