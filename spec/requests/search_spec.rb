require 'rails_helper'

RSpec.describe "Searching", type: :request do
  let!(:user) { FactoryGirl.create(:user, :generic) }

  context 'Search by username' do
    scenario 'using exact phrase' do
      user2 = FactoryGirl.create(:user, :generic)
      headers = sign_in_as user
      api_get search_url(scope: 'username', query: user2.username), headers

      expect(response).to have_http_status(:ok)
      body = json(response.body)
      expect(body).to have_key(:results)

      search_results = body[:results]
      expect(search_results.length).to be(1) # Unique user
      expect(search_results[0][:id]).to eq(user2.id)
      expect(search_results[0][:username]).to eq(user2.username)
    end

    scenario 'using part of username' do
      # To ensure that the part of the name does not include
      # the original user we created above, we just append a
      # random character to the entire username of :user
      keyword = user.username << "0"
      user1 = FactoryGirl.create(:user, :generic, username: keyword + "1")
      user2 = FactoryGirl.create(:user, :generic, username: keyword + "2")
      # Create a dummy username that matches none
      FactoryGirl.create(:user, :generic, username: ("1" + keyword).reverse)

      headers = sign_in_as user
      api_get search_url(scope: 'username', query: keyword), headers

      search_results = json(response.body)[:results]
      expect(search_results.length).to be(2)
      expect(search_results).to contain_exactly(
        { id: user1.id, username: user1.username },
        { id: user2.id, username: user2.username }
      )
    end
  end
end
