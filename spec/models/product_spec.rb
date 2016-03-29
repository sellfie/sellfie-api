require 'rails_helper'

RSpec.describe Product, type: :model do

  let!(:product) { FactoryGirl.build_stubbed(:product) }

  #
  # Product Name
  #
  context 'Name' do
    it 'is invalid without a name' do
      product.name = nil
      expect(product).to_not be_valid
    end
  end

  #
  # Product Description
  #
  context 'Description' do
    it 'is valid without a description' do
      product.description = nil
      expect(product).to be_valid
    end
  end

  #
  # Condition
  #
  context 'Condition' do
    it 'is invalid without a condition value' do
      product.condition = nil
      expect(product).to_not be_valid
    end

    it 'must have a condition value greater than or equals to one' do
      product.condition = 0
      expect(product).to_not be_valid
    end

    it 'must have a condition value smaller than or equals to ten' do
      product.condition = 11
      expect(product).to_not be_valid
    end

    it 'must have an integer condition value' do
      product.condition = 5.5
      expect(product).to_not be_valid
    end
  end

  #
  # Price
  #
  context 'Price' do
    it 'is invalid without a price' do
      product.price = nil
      expect(product).to_not be_valid
    end

    it 'must have a non-negative price' do
      product.price = -1
      expect(product).to_not be_valid
    end

    it 'can be a free product' do
      product.price = 0
      expect(product).to be_valid
    end
  end

  #
  # Shipping fee
  #
  context 'Shipping fee' do
    it 'is invalid without a shipping fee' do
      product.shipping_fee = nil
      expect(product).to_not be_valid
    end

    it 'must have a non-negative shipping fee' do
      product.shipping_fee = -1
      expect(product).to_not be_valid
    end
  end

  context 'Vendor' do
    it 'must be sold by an user' do
      product.seller = nil
      expect(product).to_not be_valid
    end
  end
end
