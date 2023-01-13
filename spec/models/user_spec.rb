require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :all
  subject(:example_user) { users(:user_one) }

  it 'is valid with valid attributes' do
    expect(example_user).to be_valid
  end

  it 'is invalid without encrypted key' do
    example_user.encrypted_key = nil
    expect(example_user).not_to be_valid
  end
end