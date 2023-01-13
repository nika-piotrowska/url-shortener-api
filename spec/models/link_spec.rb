require 'rails_helper'

RSpec.describe Link, type: :model do
  fixtures :all
  subject(:example_link) { links(:link_one) }

  it 'with valid attributes is valid' do
    expect(example_link).to be_valid
  end

  context 'with invalid attribute:' do
    context 'as user_id' do
      it 'is invalid' do
        example_link.user_id = nil
        expect(example_link).not_to be_valid
      end
    end

    context 'as long_link' do
      it 'is invalid (nil)' do
        example_link.long_link = nil
        expect(example_link).not_to be_valid
      end

      it 'is invalid (invalid format)' do
        example_link.long_link = 'invalid'
        expect(example_link).not_to be_valid
      end
    end

    context 'as shortened_link' do
      it 'is valid (assigned before validation)' do
        example_link.shortened_link = nil
        expect(example_link).to be_valid
      end
    end

    context 'as click_count' do
      it 'is invalid' do
        example_link.click_count = nil
        expect(example_link).not_to be_valid
      end
    end
  end
end
