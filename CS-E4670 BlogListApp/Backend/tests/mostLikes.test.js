const listHelper = require('../utils/listhelper')

describe('most likes', () => {
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

  const blogs2 = [
    {
      id: 1,
      title: 'Aurinko paistaa',
      author: 'Maija Meikalainen',
      url: 'www.aurinko-paistaa.com',
      likes: 6
    },
  ]

  test('of array with only one blog is that blogs likes', () => {
    const result = listHelper.mostLikes(blogs2)
    expect(result).toEqual({
      author: 'Maija Meikalainen',
      likes: 6
    })
  })

  test('of multiple blogs works correctly', () => {
    const result = listHelper.mostLikes(blogs)
    expect(result).toEqual({
      author: 'Maija Meikalainen',
      likes: 33
    })
  })
})