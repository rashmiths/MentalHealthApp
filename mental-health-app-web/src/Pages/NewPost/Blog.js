import MarkdownIt from "markdown-it";
import MdEditor from "react-markdown-editor-lite";
import "react-markdown-editor-lite/lib/index.css";

const mdParser = new MarkdownIt();

function handleEditorChange({ html, text }) {
  console.log(`Text Changed!!\nHTML:\n${html}\nText:\n${text}`);
}

export default Blog = () => {
  return (
    <div className="main">
      <h1>this is navbar</h1>
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