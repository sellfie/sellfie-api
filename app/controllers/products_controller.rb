class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.includes(:category, :seller).all

    respond_to do |format|
      format.json { render status: :ok }
    end
  end

  def create
    product = Product.new(product_create_params)
    # Assign seller to current user
    product.seller = current_user

    if product.save
      respond_to do |format|
        format.json { head :created }
      end
    else
      respond_to do |format|
        format.json do
          render json: { errors: product.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def product_create_params
    params.require(:product).permit(:name, :description, :condition, :price, :shipping_fee)
  end
end
