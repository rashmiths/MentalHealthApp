import { useContext, useRef } from 'react';
// import MarkdownIt from "markdown-it";
// import MdEditor from "react-markdown-editor-lite";
// import "react-markdown-editor-lite/lib/index.css";
import firestore, { auth } from '../../firebaseConfig';
import { CKEditor } from '@ckeditor/ckeditor5-react';
import ClassicEditor from '@ckeditor/ckeditor5-build-classic';
import UserContext from '../../Context/UserContext';

// const mdParser = new MarkdownIt();

export default function Blog() {
  const postsRef = firestore.collection('posts');
  const editorRef = useRef(null);

  const {user} = useContext(UserContext);

  const handleSubmitBlog = () => {
    const { uid } = auth.currentUser;
    const content = editorRef.current.getData();
    const d = new Date();
    const post = {
      createdAt: d.toISOString(),
      author: uid,
      content,
      type: 'blog'
    }
    // console.log("Posting: ", post);
    postsRef.add(post)
      .then(() => console.log("Posted:", post))
      .catch(error => console.error(error));
  }

  if(!user){
    return <p>Please sign in to write a blog..</p>
  }

  if(!user.contentCreator){
    return <p>You need to be a content creator to be able to write blogs...</p>
  }
  
  return (
    <div className="main">
      <button onClick={handleSubmitBlog}>finish</button>
      <CKEditor
        editor={ClassicEditor}
        data="<p>Hello from CKEditor 5!</p>"
        onReady={editor => {
          editorRef.current = editor;
        }}
      />
    </div>
  );
};