require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :all
  subject(:example_user) { users(:user_one) }

  context 'with valid attributes' do
    it 'is valid' do
      expect(example_user).to be_valid
    end
  end

  context 'with invalid attribute:' do
    context 'example_user' do
      it 'is valid (assigned before validation)' do
        example_user.encrypted_key = nil
        expect(example_user).to be_valid
      end
    end
  end
end
