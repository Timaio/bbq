class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[show index]

  # Pundit
  after_action :verify_authorized

  # GET /events
  def index
    authorize Event
    @events = policy_scope(Event).order(created_at: :desc)
  end

  # GET /events/1
  def show
    @new_comment = @event.comments.build(params[:comment])
    @new_photo = @event.photos.build(params[:photo]) if current_user.present?
    @subscription = (current_user && @event.subscriptions.find_by(user_id: current_user.id)) ||
      @event.subscriptions.build(params[:subscription])
  end

  # GET /events/new
  def new
    authorize Event

    @event = current_user.events.build
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    authorize Event

    @event = current_user.events.new(event_params)

    if @event.save
      redirect_to @event, notice: I18n.t("controllers.events.created")
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: I18n.t("controllers.events.updated")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url, notice: I18n.t("controllers.events.destroyed")
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = authorize Event.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def event_params
    params.require(:event).permit(:title, :address, :datetime, :description)
  end
end
