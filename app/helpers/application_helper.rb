module ApplicationHelper
  def user_avatar(user)
    asset_path("user.png")
  end

  def anonymous_user_avatar
    asset_path("user.png")
  end

  def event_img(event)
    asset_path("event.jpg")
  end
end
