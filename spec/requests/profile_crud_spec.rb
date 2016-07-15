require 'rails_helper'

RSpec.describe "Profile CRUD", type: :request do
  let!(:user) { FactoryGirl.create(:user, :generic) }

  context 'Viewing a profile' do
    scenario 'using an existing ID' do
      user2 = FactoryGirl.create(:user, :generic)
      headers = sign_in_as user
      api_get user_url(user2.id), headers

      expect(response).to have_http_status(:ok)
      body = json(response.body)
      expect(body.keys).to contain_exactly(
        :id, :email, :username,
        :name, :gender, :nationality,
        :age, :address, :phone
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

    scenario 'of a user with minimal attributes' do
      user2 = FactoryGirl.create(:user, :generic, :minimal)
      headers = sign_in_as user
      api_get user_url(user2.id), headers

      expect(response).to have_http_status(:ok)
      body = json(response.body)
      expect(body.keys).to contain_exactly(
        :id, :email, :username,
        :name, :gender, :nationality
      )
      body.keys.each do |attr|
        expect(body[attr]).to eq(user2.send(attr))
      end
    end
  end

  context 'Editing a profile' do
    let!(:new_attributes) {{
      name: 'Donald Trump',
      email: 'donald@trump.com',
      username: 'donaldjtrump',
      gender: 'female',
      nationality: 'Murican',
      age: 5,
      phone: '(+1) 334 1337',
      address: '1 Trump Tower'
    }}

    scenario "using one's own ID and valid parameters" do
      headers = sign_in_as user
      api_patch user_url(user.id), { user: new_attributes }, headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to_not be_empty
      body = json(response.body)
      expect(body.to_a).to include(*new_attributes.to_a)

      user.reload
      expect(user).to have_attributes(new_attributes)
    end

    scenario "using another person's ID and valid parameters" do
      user2 = FactoryGirl.create(:user, :generic)
      headers = sign_in_as user
      api_patch user_url(user2.id), { user: new_attributes }, headers

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to_not be_empty
      body = json(response.body)
      expect(body[:errors]).to_not be_empty
      expect(body.keys).to_not include(*user2.attributes.keys)
    end

    scenario "using one's own ID and existing username" do
      user2 = FactoryGirl.create(:user, :generic)
      new_attributes[:username] = user2.username
      headers = sign_in_as user
      api_patch user_url(user.id), { user: new_attributes }, headers

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to_not be_empty
      body = json(response.body)
      expect(body[:errors]).to_not be_empty
    end

    [ :username, :email, :name, :gender, :nationality].each do |required_attr|
      scenario "using one's own ID and nil #{required_attr}" do
        new_attributes[required_attr] = nil
        headers = sign_in_as user
        api_patch user_url(user.id), { user: new_attributes }, headers

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to_not be_empty
        body = json(response.body)
        expect(body[:errors]).to_not be_empty
      end
    end
  end

end
