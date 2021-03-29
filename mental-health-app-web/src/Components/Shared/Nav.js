import { Link } from "react-router-dom";
import { useAuth } from "../../Context/AuthContext";


export default function Nav() {
    const {currentUser, logout} = useAuth();
    return (
        <nav>
            <h1>Mental Health App</h1>
            {currentUser ? <p onClick={logout}>Sign Out</p> 
            :
            <>
                <Link to="sign_in">Sign In</Link>{' '}
                <Link to="sign_up">Sign Up</Link>
            </>}

        </nav>
    )
}
