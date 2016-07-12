class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find_by(id: params[:id])
    if @user
      respond_to do |format|
        format.json { render 'show', status: :ok }
      end
    else
      respond_to do |format|
        format.json { render json: {
          errors: 'User not found'
        }, status: :unprocessable_entity }
      end
    end
  end
end
