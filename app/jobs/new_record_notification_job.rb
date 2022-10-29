class NewRecordNotificationJob < ApplicationJob
  queue_as :default

  def perform(record)
    event = record.event

    # Notify all subscribers and event creator except record creator
    emails = event.subscriptions.map(&:user_email) + [event.user.email] - [record.user&.email]

    case record
    when Comment then EventMailer.comment(record, emails).deliver_now
    when Photo   then EventMailer.photo(record, emails).deliver_now
    end
  end
end
