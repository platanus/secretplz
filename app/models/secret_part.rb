class SecretPart < ApplicationRecord
  belongs_to :secret

  validates_presence_of :secret, :encrypted_data
  validates_uniqueness_of :key, scope: [:secret_id]
end

# == Schema Information
#
# Table name: secret_parts
#
#  id             :bigint(8)        not null, primary key
#  secret_id      :bigint(8)
#  key            :string(255)
#  encrypted_data :text(65535)
#
# Indexes
#
#  index_secret_parts_on_secret_id  (secret_id)
#
# Foreign Keys
#
#  fk_rails_...  (secret_id => secrets.id)
#
