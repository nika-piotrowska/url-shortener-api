require 'rails_helper'

RSpec.describe 'ApplicationControllers', type: :request do
  fixtures :all
  let(:link) { links(:link_one) }

  describe 'GET /' do
    context 'when no params are provided' do
      it 'redirects to safe redirect domain' do
        get '/'
        expect(response).to redirect_to ENV['SAFE_REDIRECT_DOMAIN']
      end
    end

    context 'when params are provided' do
      it 'redirects to mathcing long link' do
        get link.shortened_link
        expect(response).to redirect_to link.long_link
      end
    end
  end

  context 'when no params are provided' do
    describe '* /*unmatched'
    it 'redirects to safe redirect domain' do
      get '/unknown/route'
      expect(response).to redirect_to ENV['SAFE_REDIRECT_DOMAIN']
    end
  end
end
