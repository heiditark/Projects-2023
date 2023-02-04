import Blog from './components/Blog'
import Title from './components/Title'
import Author from './components/Author'
import Url from './components/Url'
import Notification from './components/Notification'
import { useState, useEffect } from 'react'
//import axios from 'axios'
import blogService from './services/blogs'
import loginService from './services/login'

const App = () => {
  const [blogs, setBlogs] = useState([])
  const [newBlog, setNewBlog] = useState({
    title:'',
    author:'',
    url:'',
    likes: 0
  })
  const [username, setUsername] = useState('') 
  const [password, setPassword] = useState('') 
  const [user, setUser] = useState(null)
  const [notification, setNotification] = useState(null)

 useEffect(() => {
  blogService
    .getAll().then(initialBlogs => {
      setBlogs(initialBlogs)
    })
}, [])

  useEffect(() => {
    const loggedUserJSON = window.localStorage.getItem('loggedBloglistAppUser')
    if (loggedUserJSON) {
      const user = JSON.parse(loggedUserJSON)
      setUser(user)
      blogService.setToken(user.token)
    }
  }, [])

  const notify = (message, type='info') => {
    setNotification({ message, type })
    setTimeout(() => {
      setNotification(null)
    }, 3000)
  }

  const addBlog = (event) => {
    event.preventDefault()
    console.log('button clicked', event.target)
    
    const blogObject = {
      title: newBlog.title,
      author: newBlog.author,
      url: newBlog.url,
      likes: 0,
    }

    blogService
      .create(blogObject)
        .then(returnedBlog => {
          setBlogs(blogs.concat(returnedBlog))
          setNewBlog({title:'', author:'', url:'', likes: 0})
          notify(`A new blog '${blogObject.title}' added by ${blogObject.author}`)
        })
  }

  const handleBlogChange = (event) => {
    console.log(event.target.value)
    setNewBlog(event.target.value)

    const fieldValue = event.target.value
    const fieldName = event.target.name
    const newFieldValue = {...newBlog,[fieldName]:fieldValue}
    setNewBlog(newFieldValue)
  }

  const addLikeTo = id => {
    const blog = blogs.find(n => n.id === id)
    const changedBlog = { ...blog, likes: blog.likes + 1 }

    blogService
      .update(id, changedBlog)
        .then(returnedBlog => {
        setBlogs(blogs.map(blog => blog.id !== id ? blog : returnedBlog))
        notify(`Like added to '${blog.title}'`)
      })
      .catch(error => {
        notify(
          `the blog '${blog.title}' was already deleted from server`, 'alert'
        )
        setBlogs(blogs.filter(n => n.id !== id))
      })
  }

  const handleLogin = async (event) => {
    event.preventDefault()
    try {
      const user = await loginService.login({
        username, password,
      })
      notify(`${user.name} logged in`)
      window.localStorage.setItem(
        'loggedBloglistAppUser', JSON.stringify(user)
      ) 
      blogService.setToken(user.token)
      setUser(user)
      setUsername('')
      setPassword('')
    } catch (exception) {
      notify('Wrong username or password', 'alert')
    }
  }

  const handleLogOut = () => {
    notify(`${user.name} logged out`)
    setUser(null)
    window.localStorage.removeItem('loggedBloglistAppUser')
  }

  const loginForm = () => (
    <div class="main1">
      <p class="sign" align="center" >Sign in </p>
      <Notification notification={notification} />
      <form class="form1" onSubmit={handleLogin}>
        <div>
            <input 
            class="un"
            placeholder="Username"
            align="center"
            type="text"
            value={username}
            name="Username"
            onChange={({ target }) => setUsername(target.value)}
          />
        </div>
        <div>
            <input
            class="pass"
            align="center"
            placeholder="Password"
            type="password"
            value={password}
            name="Password"
            onChange={({ target }) => setPassword(target.value)}
          />
        </div>
        <button class="signIn" type="submit" align="center">Sign in</button>
      </form>
    </div>      
  )

  const blogForm = () => (
    <div>
      <Notification notification={notification} />
      <div class="main2">
      <p class="sign" align="center" >Add a new</p>
        <form class="form2" align="center" onSubmit={addBlog}>
          <Title title={newBlog.title} 
            handleBlogChange={handleBlogChange} 
          />
          <Author author={newBlog.author} 
            handleBlogChange={handleBlogChange} 
          />
          <Url url={newBlog.url} 
            handleBlogChange={handleBlogChange} 
          />
          <button class="save" type="submit" align="center" >Save</button>
        </form>
      </div>
      <ul class="bloglist">
        {blogs.map(blog => 
          <Blog key={blog.id}
            blog={blog}
            addLike={() => addLikeTo(blog.id)}/>
        )}
      </ul>
   </div>
  )
//<Notification notification={notification} />
  return (
    <div>
      <h1 class="title" align="center"> Blogs </h1>
        {user === null ? 
        loginForm() :
        <div>
          {blogForm()}
          <p class="logOutElement" align="center"> {user.name} logged in
            <button class="logOut" onClick={handleLogOut}> {'Log out'}</button>
          </p>
        </div>
        }
    </div>
  )
}

export default App