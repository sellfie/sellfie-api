require 'rails_helper'

describe User do
  let!(:user) { FactoryGirl.build(:user, :generic) }

  context 'Validation' do
    [ :email, :username, :name, :gender, :nationality ].each do |required_attr|
      it "is invalid without a #{required_attr}" do
        user.send("#{required_attr}=", nil)
        expect(user).to_not be_valid
      end
    end

    [ :age, :address, :phone ].each do |optional_attr|
      it "is valid without a #{optional_attr}" do
        user.send("#{optional_attr}=", nil)
        expect(user).to be_valid
      end
    end
  end
end
