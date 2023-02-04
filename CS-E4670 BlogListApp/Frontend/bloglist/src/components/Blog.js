const Blog = ({ blog, addLike }) => {
    return (
      <div id="blogs">
        <element class="arrow arrow-right"> </element>
        <link rel='stylesheet' href='https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css'></link>
        <li>
            <element class="blog">{blog.title}, {blog.author}. Likes: {blog.likes}
              <button class="likeButton" onClick={addLike}>
                <i class="fa fa-heart-o"></i>
              </button>
            </element>
        </li>
      </div>
    )
}

export default Blog