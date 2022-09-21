module ApplicationHelper
  def user_avatar(user=nil)
    if user && user.avatar.attached?
      user.avatar.variant(resize_to_fill: [400, 400])
    else
      asset_path("user.png")
    end
  end

  def user_avatar_thumb(user=nil)
    if user && user.avatar.attached?
      user.avatar.variant(resize_to_fill: [60, 60])
    else
      asset_path("user.png")
    end
  end

  def event_img(event)
    photos = event.photos.persisted
    photos.any? ? photos.sample.photo : asset_path("event.jpg")
  end
end
