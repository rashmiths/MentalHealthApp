import { Link } from "react-router-dom";

export default function Home () {
    return (
        <div>
            <h1>Hi!</h1>
            <p>This is the home page but hasn't been implemented yet :/</p>
            <p>meanwhile, you can try creating a blog type input <Link to="/new/blog">here</Link></p>
        </div>
    )
}
