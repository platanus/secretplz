class Secret < ApplicationRecord
  attr_readonly :uuid

  has_many :parts, class_name: 'SecretPart', inverse_of: :secret

  validates_presence_of :public_key
  validate :not_sealed

  before_validation :generate_uuid, on: :create

  def sealed?
    !sealed_at.nil?
  end

  def seal!
    update! sealed_at: Time.current
  end

  private

  def generate_uuid
    self.uuid = SecureRandom.uuid
  end

  def not_sealed
    errors.add(:base, 'already sealed') if sealed_at_was.present?
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
#  sealed_at  :datetime
#
