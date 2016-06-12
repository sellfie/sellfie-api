class MessagesController < ApplicationController
  before_action :authenticate_user!

  def check
    since = Time.at(params[:since].to_i).to_datetime
    @messages = Message.where('to_id = ? AND created_at > ?',
                             current_user.id,
                             since)
    if !@messages || @messages.empty?
      head :no_content
    else
      respond_to do |format|
        format.json { render :index, status: :ok }
      end
    end
  end

  def send_to
    receiver = User.find(params[:user_id])

    if receiver
      message = Message.new(message_send_params)
      message.sender = current_user
      message.receiver = receiver

      if message.save
        respond_to do |format|
          format.json { head :ok }
        end
      else
        respond_to do |format|
          format.json do
            render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end

    else # Receiver not found
      # TODO: Write receiver not found
    end
  end

  private

  def message_send_params
    params.require(:message).permit(:content)
  end
end
