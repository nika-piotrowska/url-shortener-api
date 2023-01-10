class User < ApplicationRecord
  encrypts :encrypted_key, deterministic: true
end
