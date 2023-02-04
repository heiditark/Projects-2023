function UrlInputField({handleBlogChange, url}){
    return (
            <input type="text" 
                class="url"
                align="center"
                onChange={handleBlogChange}
                value={url} name="url"
                placeholder="Url"
            />
    );
}

export default UrlInputField