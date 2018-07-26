class Secret < ApplicationRecord
  has_many :parts, class_name: 'SecretPart', inverse_of: :secret

  validates_presence_of :public_key
end

# == Schema Information
#
# Table name: secrets
#
#  id         :bigint(8)        not null, primary key
#  public_key :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_secrets_on_public_key  (public_key)
#
