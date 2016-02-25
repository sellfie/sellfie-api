require 'rails_helper'

RSpec.describe 'Authentication API', type: :request do

  context 'User has not signed in and' do
    scenario 'tries to sign in using valid credentials' do
      user = FactoryGirl.build(:user, :unconfirmed)

      expect {
        post user_registration_path, {
          email: user.email,
          password: user.password,
          password_confirmation: user.password,
          confirm_success_url: ''
        }
      }.to change { User.count }.by(1)
        .and change { ActionMailer::Base.deliveries.count }.by(1)

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq(Mime::JSON)

      # Verify created user
      created_user = User.last
      expect(created_user.email).to eq(user.email)
      expect(created_user).to_not be_confirmed

      # Verify email sent
      mail = ActionMailer::Base.deliveries.last
      expect(mail.to).to include(user.email)

      # Created user cannot log in
      post user_session_path, {
        email: user.email,
        password: user.password
      }
      expect(response).to have_http_status(:unauthorized)
      expect(response.content_type).to eq(Mime::JSON)
      body = json(response.body)
      expect(body).to have_key(:errors)
    end

  end

  context 'User has already confirmed email and' do
    scenario 'tries to sign in using valid credentials' do
      user = FactoryGirl.create(:user)
      post user_session_path, {
        email: user.email,
        password: user.password
      }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq(Mime::JSON)

      # Response header must have 'access-token' and 'client'
      header = response.header
      ['access-token', 'client'].each do |key|
        expect(header).to have_key(key)
        expect(header[key]).to_not be_nil
        expect(header[key]).to_not be_empty
      end
    end
  end
end
