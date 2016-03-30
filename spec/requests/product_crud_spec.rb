require 'rails_helper'

RSpec.describe 'Product CRUD Operations', type: :request do

  #
  # Initialization
  #
  let!(:user) { FactoryGirl.create(:user, :vendor) }
  let(:original_header) { sign_in_as user }

  context 'Creating' do

    scenario 'User create product with valid parameters' do
      product_params = {
        :product => FactoryGirl.attributes_for(:product, :vendorless)
          .reject { |k, v| [:seller_id].include? k }
      }

      expect {
        api_post products_url, product_params, original_header
      }.to change { Product.count }.by(1)
        .and change { user.products.count }.by(1)

      expect(response).to have_http_status(:created)
    end

    scenario 'User create product with invalid parameters' do
      product_params = {
        :product => FactoryGirl.attributes_for(:product, :vendorless)
          .reject { |k, v| [:name, :seller_id].include? k }
      }

      expect {
        api_post products_url, product_params, original_header
      }.to change { Product.count }.by(0)
        .and change { user.products.count }.by(0)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to_not be_empty

      body = json(response.body)
      expect(body).to have_key(:errors)
      expect(body[:errors]).to_not be_empty
    end
  end

end