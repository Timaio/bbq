class PhotosController < ApplicationController
  before_action :set_event, only: %i[create destroy]
  before_action :set_photo, only: :destroy

  # POST /photos
  def create
    @new_photo = @event.photos.build(photo_params)
    @new_photo.user = current_user

    if @new_photo.save
      redirect_to @event, notice: I18n.t("controllers.photos.created")
    else
      render "events/show", alert: I18n.t("controllers.photos.error")
    end
  end

  # DELETE /photos/1
  def destroy
    message = {notice: I18n.t("controller.photos.destroyed")}
    
    if current_user_can_edit?(@photo)
      @photo.destroy
    else
      message = {alert: I18n.t("access_denied")}
    end
    
    redirect_to @event, message
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:event_id])
    end

    def set_photo
      @photo = Photo.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def photo_params
      params.fetch(:photo, {}).permit(:photo)
    end
end
