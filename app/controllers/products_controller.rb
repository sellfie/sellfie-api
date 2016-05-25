class ProductsController < ApplicationController
  before_action :authenticate_user!

  def index
    @products = Product.includes(:category, :seller).all

    respond_to do |format|
      format.json { render status: :ok }
    end
  end

  def create
    create_params = product_create_params

    # Create uploaded photos
    if create_params.has_key? :photos
      uploaded_file = create_product_photos(create_params[:photos])
      create_params[:photos] = uploaded_file
    end

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

  ensure
    clean_temp_files
  end

  private

  def product_create_params
    params.require(:product).permit(:name, :description, :condition, :price, :shipping_fee, { photos: []})
  end

  def create_product_photos(photos)
    @uploaded_files = []
    photos.each do |photo|
      file = Tempfile.new('product_photo')
      file.binmode
      file.write Base64.decode64(photo[:content])
      file.rewind

      filename = current_user.id.to_s << Digest::MD5.hexdigest(photo[:filename])
      filename << "_" << Digest::MD5.hexdigest(Time.now.to_s)

      uploaded_file = ActionDispatch::Http::UploadedFile.new(
        tempfile: file,
        filename: filename
      )

      uploaded_file.content_type = photo[:content_type]
      @uploaded_files << {
        temp: file,
        uploaded: uploaded_file
      }
    end
    @uploaded_files
  end

  def clean_temp_files
    return unless @uploaded_files && !@uploaded_files.empty?
    @uploaded_files.map { |u| u[:temp] }.each do |tempfile|
      tempfile.close
      tempfile.unlink
    end
  end
end
