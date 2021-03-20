import './App.css';
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';
import { useAuthState } from 'react-firebase-hooks/auth';
import { auth } from './firebaseConfig';
import SignIn, { SignOut } from './Pages/SignIn_SignOut';
import NewPost from './Pages/NewPost';
import Home from './Pages/Home';

function App() {

  const [user] = useAuthState(auth);

  console.log("useAuthState:", user);

  return (
    <div className="App">
      <header>
        <h1>Mental Health App</h1>
        {user ? <SignOut /> : <SignIn />}
      </header>

      <BrowserRouter>
        <Routes>
          <Route path="/" element={<Home/>} />
          <Route path="new/*" element={<NewPost/>}/>
        </Routes>
      </BrowserRouter>

    </div>
  );
}

export default App;
