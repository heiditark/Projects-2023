/* eslint-disable no-unused-vars */
const { keyBy, maxBy } = require('lodash')
const _ = require('lodash')

const dummy = (blogs) => {
  return 1
}

const totalLikes = (blogs) => {
  return blogs.map(b => b.likes).reduce((a, b) => a + b, 0)
}

const favoriteBlog = (blogs) => {
  return blogs.reduce(
    (prev, current) => {
      return prev.likes > current.likes ? prev : current
    }, {})
}

const mostBlogs = (blogs) => {
  const mappedToAmount = _.map(_.countBy(blogs, 'author'),
    (val, key) => ({ author: key, blogs: val }))
  const max = _.maxBy(mappedToAmount, 'blogs')

  if(max === undefined) return {}
  else { return (
    {
      author: max.author,
      blogs: max.blogs
    }
  )
  }
}

const mostLikes = (blogs) => {
  if(blogs.length === 0) {
    return null
  }

  const groupedByAuthor = _.groupBy(blogs, 'author')
  const mappedToTotalLikes = _.mapValues(groupedByAuthor,
    (value) => { return _.sumBy(value, 'likes') })
  const schemad = _.map(mappedToTotalLikes, (key, value) => {
    return {
      author: value,
      likes: key
    }
  })
  const max = _.maxBy(schemad, 'likes')

  return {
    author: max.author,
    likes: max.likes
  }
}

module.exports = {
  dummy,
  totalLikes,
  favoriteBlog,
  mostBlogs,
  mostLikes
}