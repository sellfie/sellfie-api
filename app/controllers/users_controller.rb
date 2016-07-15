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

  def update
    if params[:id].to_i == current_user.id
      @user = current_user
      result = @user.update_attributes(user_update_params)
      if result
        # Saving succeeded
        respond_to do |format|
          format.json { render 'show', status: :ok }
        end
      else
        # Saving failed
        respond_to do |format|
          format.json { render json: {
            errors: @user.errors
          }, status: :unprocessable_entity }
        end
      end

    else
      respond_to do |format|
        format.json { render json: {
          errors: "You may not modify someone else's profile"
        }, status: :unauthorized }
      end
    end
  end

  private

  def user_update_params
    # TODO: Verify email
    params.require(:user).permit(
      :username, :email,
      :name, :gender, :nationality,
      :age, :phone, :address
    )
  end
end
