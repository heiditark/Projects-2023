/*const mongoose = require('mongoose')

if (process.argv.length<3) {
  console.log('give password as argument')
  process.exit(1)
}

const password = process.argv[2]

const url =
  `mongodb+srv://fullstackHeidi:${password}@cluster0.8jaen0f.mongodb.net/Bloglist?retryWrites=true&w=majority`

mongoose.connect(url)

const blogSchema = mongoose.Schema({
    title: String,
    author: String,
    url: String,
    likes: Number
})

const Blog = mongoose.model('Blog', blogSchema)

const blog = new Blog({
    title: 'Pekkaniksit',
    author: 'Pekka',
    url: 'www.pekka.fi',
    likes: 2
})

Blog.find({}).then(result => {
    result.forEach(blog => {
      console.log(blog)
    })
    mongoose.connection.close()
  })*/