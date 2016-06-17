class SearchController < ApplicationController

  def search
    search_method = "search_for_#{params[:scope]}"

    unless self.methods.include?(search_method.intern)
      respond_to do |format|
        format.json { render json: { errors: ['Unrecognized scope'] },
                             status: :unprocessable_entity }
      end
    else
      self.send(search_method, params[:query])
    end
  end

  def search_for_username(query)
    @users = User.where("lower(username) LIKE '%#{query.downcase}%'")
      .limit(10).all
    respond_to do |format|
      format.json { render :users, status: :ok }
    end
  end
end
