import React, { useContext, useState, useEffect, useRef } from "react";
import firestore, { auth } from "../firebaseConfig";
import firebase from "firebase/app";
import { useToast } from "@chakra-ui/react";

const AuthContext = React.createContext();

export function useAuth() {
    return useContext(AuthContext);
}

export default function AuthProvider({ children }) {
    const [currentUser, setCurrentUser] = useState();
    const [loading, setLoading] = useState(true);
    const newUserName = useRef('');
    const toast = useToast();

    function signUpWithEmailAndPassword(name, email, password) {
        newUserName.current=name;
        console.log(name);
        return auth.createUserWithEmailAndPassword(email, password);
    }

    function signInWithGoogle() {
        const provider = new firebase.auth.GoogleAuthProvider();
        return auth.signInWithPopup(provider);
    }

    function loginWithEmailAndPassword(email, password) {
        return auth.signInWithEmailAndPassword(email, password);
    }

    async function logout() {
        await auth.signOut();
        const toastID = "signout-succ";
        if (!toast.isActive(toastID)) {
            toast({
                id: toastID,
                title: `Signed out successfully`,
                status: "success",
                isClosable: true,
                position: "top-right",
            });
        };
    }

    function resetPassword(email) {
        return auth.sendPasswordResetEmail(email)
    }

    useEffect(() => {
        const usersRef = firestore.collection("users");
        const unsubscribe = auth.onAuthStateChanged(async (user) => {
            if (!user) {
                setCurrentUser(null);
                setLoading(false);
                return;
            }
            let currentUser = {};
            const snapshot = await usersRef.doc(user.uid).get();
            if (!snapshot.exists) {
                console.log("Inside", newUserName);
                const newUser = {
                    email: user.email,
                    name: user.displayName || newUserName.current,
                    contentCreator: false,
                    photoURL: user.photoURL,
                    admin: false,
                };
                await usersRef.doc(user.uid).set(newUser);
                currentUser = { ...newUser, uid: user.uid };
            } else {
                currentUser = { ...snapshot.data(), uid: user.uid };
            }
            newUserName.current='';
            setCurrentUser(currentUser);
            setLoading(false);

            const toastID = `${currentUser.uid}-signin-succ`;
            if (!toast.isActive(toastID)) {
                toast({
                    id: toastID,
                    title: `Signed in as ${currentUser.name}`,
                    status: "success",
                    isClosable: true,
                    position: "top-right",
                });
            }
        });

        return unsubscribe;
    }, []);

    const value = {
        currentUser,
        loginWithEmailAndPassword,
        signUpWithEmailAndPassword,
        signInWithGoogle,
        logout,
        resetPassword,
    };

    return (
        <AuthContext.Provider value={value}>
            {!loading && children}
        </AuthContext.Provider>
    );
}
