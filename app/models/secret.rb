class Secret < ApplicationRecord
  attr_readonly :uuid

  has_many :parts, class_name: 'SecretPart', inverse_of: :secret

  validates_presence_of :public_key

  before_validation :generate_uuid, on: :create

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end
end

# == Schema Information
#
# Table name: secrets
#
#  id         :bigint(8)        not null, primary key
#  public_key :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uuid       :string(255)
#
