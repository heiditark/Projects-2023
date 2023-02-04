const mostBlogs = require('../utils/listhelper').mostBlogs

describe('most blogs', () => {
  test('of empty array is none', () => {
    const blogs = []
    expect(mostBlogs(blogs)).toEqual({})
  })

  test('of many is calculated right', () => {
    const blogs = [
      {
        id: 1,
        title: 'Aurinko paistaa',
        author: 'Maija Meikalainen',
        url: 'www.aurinko-paistaa.com',
        likes: 6
      },
      {
        id: 2,
        title: 'Täysikuu',
        author: 'Maija Meikalainen',
        url: 'www.taysi-kuu.com',
        likes: 3
      },
      {
        id: 3,
        title: 'Pirkkaniksit',
        author: 'Maija Meikalainen',
        url: 'www.pirkat.com',
        likes: 24
      },
      {
        title: 'j',
        author: 'k',
        url: 'k',
        likes: 4,
        id: 4
      }
    ]

    expect(mostBlogs(blogs)).toEqual(
      {
        author: 'Maija Meikalainen',
        blogs: 3
      }
    )
  })

  test('of one blog is the author itself', () => {
    const blogs = [
      {
        id: 1,
        title: 'Aurinko paistaa',
        author: 'Maija Meikalainen',
        url: 'www.aurinko-paistaa.com',
        likes: 6
      }
    ]
    expect(mostBlogs(blogs)).toEqual(
      {
        author: 'Maija Meikalainen',
        blogs: 1
      }
    )
  })
})