const Blog = require('../models/blog')
const User = require('../models/user')

const initialBlogs = [
  {
    title: 'Aurinko paistaa',
    author: 'Maija Meikalainen',
    url: 'www.aurinko-paistaa.com',
    likes: 6
  },
  {
    title: 'Täysikuu',
    author: 'Matti Meikalainen',
    url: 'www.taysi-kuu.com',
    likes: 3
  },
  {
    title: 'Pirkkaniksit',
    author: 'Monni Kala',
    url: 'www.pirkat.com',
    likes: 24
  }
]

const nonExistingId = async () => {
  const blog = new Blog({ title: 'Miuku', author: 'Mauku', url: 'www.kissat.com', likes: 0 })
  await blog.save()
  await blog.remove()

  return blog._id.toString()
}

const blogsInDb = async () => {
  const blogs = await Blog.find({})
  return blogs.map(blog => blog.toJSON())
}

const usersInDb = async () => {
  const users = await User.find({})
  return users.map(u => u.toJSON())
}

module.exports = {
  initialBlogs, nonExistingId, blogsInDb, usersInDb
}