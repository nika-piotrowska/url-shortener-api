require 'rails_helper'

RSpec.describe Link, type: :model do
  fixtures :all
  subject(:example_link) { links(:link_one) }

  it 'is valid with valid attributes' do
    expect(example_link).to be_valid
  end

  context 'when is invalid with invalid attribute:' do
    it 'user_id' do
      example_link.user_id = nil
      expect(example_link).not_to be_valid
    end

    it 'long_link' do
      example_link.long_link = nil
      expect(example_link).not_to be_valid
    end

    it 'long_link has invalid format' do
      example_link.long_link = 'invalid'
      expect(example_link).not_to be_valid
    end

    it 'shortened_link' do
      example_link.shortened_link = nil
      expect(example_link).not_to be_valid
    end

    it 'click_count' do
      example_link.click_count = nil
      expect(example_link).not_to be_valid
    end
  end
end
