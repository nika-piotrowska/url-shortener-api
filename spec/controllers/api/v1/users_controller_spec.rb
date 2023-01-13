require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  fixtures :all
  let(:user) { users(:user_one) }
  let(:req) { subject }

  describe 'POST /api/v1/users' do
    context 'without authentication' do
      subject do
        post :create
      end

      it 'has status 200' do
        expect(req).to have_http_status(:ok)
      end

      it 'renders json' do
        expect { JSON.parse(req.body) }.not_to raise_error
      end

      it 'renders proper data' do
        hash = JSON.parse(req.body)
        expect(hash['message']).not_to be_nil
        expect(hash['message']).to be_instance_of String
        expect(hash['user_api_key']).not_to be_nil
        expect(hash['user_api_key']).to be_instance_of String
      end
    end
  end

  describe 'PATCH /api/v1/users/refresh_api_key' do
    context 'without authentication' do
      subject do
        patch :refresh_encrypted_key
      end

      it 'has status 401' do
        expect(req).to have_http_status(:unauthorized)
      end

      it 'renders json' do
        expect { JSON.parse(req.body) }.not_to raise_error
      end

      it 'renders proper data' do
        hash = JSON.parse(req.body)
        expect(hash['message']).not_to be_nil
        expect(hash['message']).to be_instance_of String
      end
    end

    context 'with authentication' do
      subject do
        patch :refresh_encrypted_key
      end

      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(user.encrypted_key)
      end

      it 'has status 200' do
        expect(req).to have_http_status(:ok)
      end

      it 'renders json' do
        expect { JSON.parse(req.body) }.not_to raise_error
      end

      it 'renders proper data' do
        hash = JSON.parse(req.body)
        expect(hash['message']).not_to be_nil
        expect(hash['message']).to be_instance_of String
        expect(hash['user_api_key']).not_to be_nil
        expect(hash['user_api_key']).to be_instance_of String
      end
    end
  end
end
