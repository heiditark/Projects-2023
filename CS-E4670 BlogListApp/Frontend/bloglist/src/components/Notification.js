const Notification = ({ notification }) => {
  if (notification === null) {
    return null
  }

  if(notification.type === 'alert') {
    return (
      <div align="center" class="error">
        {notification.message}
      </div>
    )
  } else {
    return (
      <div align="center" class="notification">
        {notification.message}
      </div>
    )
  }
}

export default Notification