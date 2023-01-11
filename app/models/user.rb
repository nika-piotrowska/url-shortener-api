class User < ApplicationRecord
  encrypts :encrypted_key, deterministic: true
  has_many :links, dependent: :destroy

  before_create :set_encrypted_key

  private
    def set_encrypted_key
      self.encrypted_key = SecureRandom.uuid if self.encrypted_key.nil?
    end
end
