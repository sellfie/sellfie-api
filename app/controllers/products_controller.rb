class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.includes(:category, :seller).all

    respond_to do |format|
      format.json { render status: :ok }
    end
  end
end
