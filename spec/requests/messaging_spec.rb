require 'rails_helper'

RSpec.describe 'Messaging', type: :request do

  #
  # Initialization
  #
  let!(:sender) { FactoryGirl.create(:user, :generic) }
  let!(:receiver) { FactoryGirl.create(:user, :generic) }

  context 'Sending messages' do
    scenario 'Sender sends message with valid params' do
      headers = sign_in_as sender
      message_params = { message: { content: "Hello World!" } }
      expect {
        api_post send_message_to_user_url(user_id: receiver.id), message_params, headers
      }.to change { Message.count }.by(1)

      expect(response).to have_http_status(:ok)
      expect(response.body).to be_empty

      message = Message.last
      expect(message.sender).to eq(sender)
      expect(message.receiver).to eq(receiver)
      expect(message.content).to eq("Hello World!")

    end

    scenario 'Receiver checks message when there is no incoming message' do
      headers = sign_in_as receiver
      yesterday_epoch = 1.day.ago.to_i
      api_get check_messages_url(since: yesterday_epoch), headers
      expect(response).to have_http_status(:no_content)
    end

    scenario 'Receiver checks message after sender sends one' do
      sender_headers = sign_in_as sender
      message_params = { message: { content: "Hello World!" } }
      api_post send_message_to_user_url(user_id: receiver.id), message_params, sender_headers



      receiver_headers = sign_in_as receiver
      api_get check_messages_url(since: 1.minute.ago), receiver_headers
      expect(response).to have_http_status(:ok)
      expect(response.body).to_not be_empty

      body = json(response.body)
      message = body[:messages].last
      expect(message[:content]).to eq("Hello World!")
      expect(message[:from_id]).to eq(sender.id)
      expect(DateTime.parse(message[:created_at]).to_time).to be_within(1.minute).of(Time.now)
    end
  end
end
