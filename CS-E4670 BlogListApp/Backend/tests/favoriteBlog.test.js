const favoriteBlog = require('../utils/listhelper').favoriteBlog

describe('favorite blog', () => {
  test('of empty array is none', () => {
    const blogs = []
    expect(favoriteBlog(blogs)).toEqual({})
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
        author: 'Matti Meikalainen',
        url: 'www.taysi-kuu.com',
        likes: 3
      },
      {
        id: 3,
        title: 'Pirkkaniksit',
        author: 'Monni Kala',
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
    expect(favoriteBlog(blogs)).toEqual(
      {
        id: 3,
        title: 'Pirkkaniksit',
        author: 'Monni Kala',
        url: 'www.pirkat.com',
        likes: 24
      }
    )
  })

  test('of one blog is the value itself', () => {
    const blogs = [
      {
        id: 1,
        title: 'Aurinko paistaa',
        author: 'Maija Meikalainen',
        url: 'www.aurinko-paistaa.com',
        likes: 6
      }
    ]
    expect(favoriteBlog(blogs)).toEqual(
      {
        id: 1,
        title: 'Aurinko paistaa',
        author: 'Maija Meikalainen',
        url: 'www.aurinko-paistaa.com',
        likes: 6
      })
  })
})