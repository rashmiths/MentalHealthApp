import { BrowserRouter, Routes, Route } from 'react-router-dom';
import NewPost from './Pages/NewPost';
import Home from './Pages/Home';
import SignIn from './Pages/SignIn';
import SignUp from './Pages/SignUp';
import AuthProvider from '../Context/AuthContext';
import Nav from './Shared/Nav';

function App() {
  return (
    <div className="App">
      <AuthProvider>
        <BrowserRouter>
        <Nav />
          <Routes>
            <Route path="/" element={<Home />} />
            <Route path="/sign_in" element={<SignIn />} />
            <Route path="/sign_up" element={<SignUp />} />
            <Route path="new/*" element={<NewPost />} />
          </Routes>
        </BrowserRouter>
      </AuthProvider>
    </div>
  );
}

export default App;
