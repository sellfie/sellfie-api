require 'rails_helper'

RSpec.describe "Profile", type: :request do
  let!(:user) { FactoryGirl.create(:user, :generic) }

  context 'Viewing a profile' do
    scenario 'using an existing ID' do
      user2 = FactoryGirl.create(:user, :generic)
      headers = sign_in_as user
      api_get user_url(user2.id), headers

      expect(response).to have_http_status(:ok)
      body = json(response.body)
      expect(body.keys).to contain_exactly(
        :id, :username, :name
      )
      body.keys.each do |attr|
        expect(body[attr]).to eq(user2.send(attr))
      end
    end

    scenario 'using a non-existend ID' do
      last_uid = User.all.map(&:id).sort.last
      non_existent_id = last_uid + 1
      headers = sign_in_as user
      api_get user_url(non_existent_id), headers

      expect(response).to have_http_status(:unprocessable_entity)
      body = json(response.body)
      expect(body.keys).to contain_exactly(:errors)
      expect(body[:errors]).to_not be_empty
    end
  end
end
