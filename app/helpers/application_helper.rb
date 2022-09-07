module ApplicationHelper
  def user_avatar(user=nil)
    user&.avatar&.url || asset_path("user.png")
  end

  def user_avatar_thumb(user=nil)
    user&.avatar&.thumb.url || asset_path("user.png")
  end

  def event_img(event)
    photos = event.photos.persisted
    photos.any? ? photos.sample.photo.url : asset_path("event.jpg")
  end

  def event_img_thumb(event)
    photos = event.photos.persisted
    photos.any? ? photos.sample.thumb.url : asset_path("event.jpg")
  end
end
