class CommentsController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_comment, only: :destroy

  # POST /comments
  def create
    @new_comment = @event.comments.build(comment_params)
    @new_comment.user = current_user

    if @new_comment.save
      notify_subscribers_and_organizator(@event, @new_comment)
      redirect_to @event, notice: I18n.t("controllers.comments.created")
    else
      @subscription = (current_user && @event.subscriptions.find_by(user_id: current_user.id)) ||
        @event.subscriptions.build(params[:subscription])

      render "events/show", alert: I18n.t("controllers.comments.error")
    end
  end

  # DELETE /comments/1
  def destroy
    message = {notice: I18n.t("controllers.comments.destroyed")}

    if current_user_can_edit?(@comment)
      @comment.destroy!
    else
      message = {alert: I18n.t("controllers.comments.error")}
    end

    redirect_to @event, message
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = @event.comments.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:body, :user_name)
  end

  def set_event
    @event = Event.find(params[:event_id])
  end

  def notify_subscribers_and_organizator(event, comment)
    all_emails = event.subscriptions.map(&:user_email).push(event.user.email)
    all_emails.delete(comment.user.email) if comment.user.present?

    all_emails.each do |email|
      EventMailer.comment(comment, email).deliver_now
    end
  end
end
