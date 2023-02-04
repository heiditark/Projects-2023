function TitleInputField({handleBlogChange, title}){
    return (
        <p>
            <input type="text" 
                class="blogTitle"
                align="center"
                onChange={handleBlogChange}
                value={title} name="title"
                placeholder="Title"
            />
        </p>
    );
}

export default TitleInputField