require 'rails_helper'

RSpec.describe 'Product Listing', type: :request do

  let!(:user) { FactoryGirl.create(:user) }

  let!(:vendor) { FactoryGirl.create(:user, :vendor) }
  let!(:category) { FactoryGirl.create(:category) }
  let!(:products) { FactoryGirl.create_list(:product, 10, seller: vendor, category: category) }

  context 'User who has not signed in' do
    scenario 'cannot get product listing' do
      get products_path

      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to eq(Mime::JSON)

      # Has error
      body = json(response.body)
      expect(body).to have_key(:errors)
      expect(body[:errors]).to_not be_empty
    end
  end

  context 'User who has signed in' do
    let!(:sign_in_header) { sign_in_as(user) }

    scenario 'can get product listing' do
      api_get products_path, sign_in_header

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq(Mime::JSON)

      # Get products body
      body = json(response.body)[:products]
      expect(body.size).to eq(products.length)

      # Only have names, description, condition, price, shipping fee, stock, and category
      first_item = body.first
      expect(first_item.keys).to contain_exactly(:name, :description, :condition, :price, :shipping_fee, :stock, :category, :seller)
    end
  end

end
