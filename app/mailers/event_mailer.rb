class EventMailer < ApplicationMailer
  def subscription(subscription)
    @subscription = subscription

    mail to: subscription.event.user.email, subject: default_i18n_subject(event_title: subscription.event.title)
  end

  def comment(comment, email)
    @comment = comment
    @commentator_name = comment.user_name
    @commentator_email = comment.user&.email || "Anonymous"

    mail to: email, subject: default_i18n_subject(event_title: comment.event.title)
  end

  def photo(photo, email)
    @photo = photo

    mail to: email, subject: default_i18n_subject(event_title: photo.event.title)
  end
end
