import { Routes, Route, Link } from 'react-router-dom';
import Blog from './Blog';
import Image from './Image';

export default function NewPost() {
    return (
        <div>
            <Routes>
                <Route path="/" element={<Choose />} />
                <Route path="blog" element={<Blog />} />
                <Route path="image" element={<Image />} />
            </Routes>
        </div>
    )
}

function Choose() {
    return (
        <div>
            <Link to="/new/image">Image type</Link>
            <Link to="/new/blog">Blog type</Link>
        </div>
    )
}
