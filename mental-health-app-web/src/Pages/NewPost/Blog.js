import { useState } from 'react';
import MarkdownIt from "markdown-it";
import MdEditor from "react-markdown-editor-lite";
import "react-markdown-editor-lite/lib/index.css";
import firestore, { auth } from '../../firebaseConfig';

const mdParser = new MarkdownIt();

export default function Blog()  {
  const [content, setContent] = useState("");
  const postsRef = firestore.collection('posts');
  const handleEditorChange = ({ text }) => setContent(text);

  const handleSubmitBlog = async () => {
    const { uid } = auth.currentUser;
    const post = {
      createdAt: Date(),
      author: uid,
      content,
      type: 'blog'
    }
    console.log("Posting: ", post);
    // await postsRef.add(post)
  }

  return (
    <div className="main">
      <button onClick={handleSubmitBlog}>finish</button>
      <div className="md-editor-wrapper">
        <MdEditor
          htmlClass="md-html"
          renderHTML={(text) => mdParser.render(text)}
          onChange={handleEditorChange}
        />
      </div>
    </div>
  );
};