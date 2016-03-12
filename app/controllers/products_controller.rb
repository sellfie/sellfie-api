class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.all

    respond_to do |format|
      format.json { render json: @products, status: :ok }
    end
  end
end
