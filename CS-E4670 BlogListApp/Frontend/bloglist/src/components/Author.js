function AuthorInputField({handleBlogChange, author}){
    return (
        <p>
            <input type="text" 
                class="author"
                align="center"
                onChange={handleBlogChange}
                value={author} name="author"
                placeholder="Author"
            />
        </p>
    );
}

export default AuthorInputField