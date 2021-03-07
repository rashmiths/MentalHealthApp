import './App.css';

import { useAuthState } from 'react-firebase-hooks/auth';
import {auth} from './firebaseConfig';
import SignIn, { SignOut } from './Pages/SignIn_SignOut';

function App() {

  const [user] = useAuthState(auth);

  return (
    <div className="App">
      <header>
        <h1>Mental Health App</h1>
        {user ? <SignOut /> : <SignIn/>}
      </header>

    </div>
  );
}

export default App;
