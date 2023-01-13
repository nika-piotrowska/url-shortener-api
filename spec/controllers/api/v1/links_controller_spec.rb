require 'rails_helper'

RSpec.describe Api::V1::LinksController, type: :controller do
  fixtures :all
  let(:link) { links(:link_one) }
  let(:req) { subject }

  describe 'POST /api/v1/links' do
    context 'without authentication' do
      subject do
        post :create
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
        post :create, params: { link: { long_link: 'https://www.youtube.com/watch?v=L1ZVLqUMghs' } }
      end

      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(link.user.encrypted_key)
      end

      it 'has status 200' do
        expect(req).to have_http_status(:ok)
      end

      it 'renders json' do
        expect { JSON.parse(req.body) }.not_to raise_error
      end

      it 'renders proper data' do
        hash = JSON.parse(req.body)
        expect(hash['id']).not_to be_nil
        expect(hash['id']).to be_instance_of Integer
        expect(hash['shortened_link']).not_to be_nil
        expect(hash['shortened_link']).to be_instance_of String
      end
    end
  end

  describe 'GET /api/v1/links/:id' do
    context 'without authentication' do
      subject do
        get :show, params: { id: 1 }
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
        get :show, params: { id: link.id }
      end

      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(link.user.encrypted_key)
      end

      it 'has status 200' do
        expect(req).to have_http_status(:ok)
      end

      it 'renders json' do
        expect { JSON.parse(req.body) }.not_to raise_error
      end

      it 'renders proper data' do
        hash = JSON.parse(req.body)
        expect(hash['link']['id']).not_to be_nil
        expect(hash['link']['id']).to be_instance_of Integer
        expect(hash['link']['long_link']).not_to be_nil
        expect(hash['link']['long_link']).to be_instance_of String
        expect(hash['link']['shortened_link']).not_to be_nil
        expect(hash['link']['shortened_link']).to be_instance_of String
        expect(hash['link']['click_count']).not_to be_nil
        expect(hash['link']['click_count']).to be_instance_of Integer
        expect(hash['link']['created_at']).not_to be_nil
        expect(hash['link']['created_at']).to be_instance_of String
        expect(hash['link']['updated_at']).not_to be_nil
        expect(hash['link']['updated_at']).to be_instance_of String
      end
    end
  end

  describe 'GET /api/v1/links/' do
    context 'without authentication' do
      subject do
        get :index
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
        get :index
      end

      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(link.user.encrypted_key)
      end

      it 'has status 200' do
        expect(req).to have_http_status(:ok)
      end

      it 'renders json' do
        expect { JSON.parse(req.body) }.not_to raise_error
      end

      it 'renders proper data' do
        hash = JSON.parse(req.body)
        expect(hash['links'][0]['id']).not_to be_nil
        expect(hash['links'][0]['id']).to be_instance_of Integer
        expect(hash['links'][0]['long_link']).not_to be_nil
        expect(hash['links'][0]['long_link']).to be_instance_of String
        expect(hash['links'][0]['shortened_link']).not_to be_nil
        expect(hash['links'][0]['shortened_link']).to be_instance_of String
        expect(hash['links'][0]['click_count']).not_to be_nil
        expect(hash['links'][0]['click_count']).to be_instance_of Integer
        expect(hash['links'][0]['created_at']).not_to be_nil
        expect(hash['links'][0]['created_at']).to be_instance_of String
        expect(hash['links'][0]['updated_at']).not_to be_nil
        expect(hash['links'][0]['updated_at']).to be_instance_of String
      end
    end
  end

  describe 'DELETE /api/v1/links/:id' do
    context 'without authentication' do
      subject do
        delete :destroy, params: { id: 1 }
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
        delete :destroy, params: { id: link.id }
      end

      before do
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(link.user.encrypted_key)
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
      end
    end
  end
end
