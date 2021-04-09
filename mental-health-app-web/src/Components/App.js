import { HashRouter, Routes, Route } from "react-router-dom";
import NewPost from "./Pages/NewPost";
import Home from "./Pages/Home";
import SignIn from "./Pages/SignIn";
import SignUp from "./Pages/SignUp";
import AuthProvider from "../Context/AuthContext";
import Nav from "./Shared/NavBar/Header";

function App() {
    return (
        <div className="App">
            <AuthProvider>
                <HashRouter>
                    <Nav />
                    <Routes>
                        <Route path="/" element={<Home />} />
                        <Route path="/sign_in" element={<SignIn />} />
                        <Route path="/sign_up" element={<SignUp />} />
                        <Route path="new/*" element={<NewPost />} />
                    </Routes>
                </HashRouter>
            </AuthProvider>
        </div>
    );
}

export default App;
