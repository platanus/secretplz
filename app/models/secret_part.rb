class SecretPart < ApplicationRecord
  belongs_to :secret

  validates_presence_of :secret, :encrypted_data
  validates_uniqueness_of :key, scope: [:secret_id]
  validate :secret_is_not_sealed

  private

  def secret_is_not_sealed
    errors.add(:secret, 'secret is sealed') if secret.present? && secret.sealed?
  end
end

# == Schema Information
#
# Table name: secret_parts
#
#  id             :bigint(8)        not null, primary key
#  secret_id      :bigint(8)
#  key            :string
#  encrypted_data :text
#
# Indexes
#
#  index_secret_parts_on_secret_id  (secret_id)
#
# Foreign Keys
#
#  fk_rails_...  (secret_id => secrets.id)
#
