class EventMailer < ApplicationMailer
  def subscription(event, subscription)
    @subscriber_email = subscription.user_email
    @subscriber_name = subscription.user_name
    @event = event

    mail to: event.user.email, subject: "Новая подписка на ваше событие #{event.title}"
  end

  def comment(event, comment, email)
    @event = event
    @comment = comment
    @commentator_name = comment.user_name
    @commentator_email = comment.user&.email || "Anonymous"

    mail to: email, subject: "Новый комментарий к вашему событию #{event.title}"
  end

  def photo(event, photo, email)
    @event = event
    @photo = photo

    mail to: email, subject: "Новая фотография к событию #{event.title}"
  end
end
