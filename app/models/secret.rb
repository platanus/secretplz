class Secret < ApplicationRecord
  BITCOIN_SIG_SIZE = 65
  BITCOIN_SIG_VERSION_RANGE = (27..30)
  BITCOIN_COMPACT_SIG_VERSION_RANGE = (21..34)

  attr_readonly :uuid

  has_many :parts, class_name: 'SecretPart', inverse_of: :secret

  validates_presence_of :public_key
  validate :not_sealed

  before_validation :generate_uuid, on: :create
  validate :valid_bitcoin_message_signature, if: 'signature.present?'

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

  def valid_bitcoin_message_signature
    bin_signature = signature.unpack('m0').first
    errors.add(:signature, 'invalid signature') unless bin_signature.bytesize == BITCOIN_SIG_SIZE

    version = bin_signature.unpack('C')[0]
    if BITCOIN_SIG_VERSION_RANGE.include? version
      errors.add(:signature, 'not compact signature')
    elsif !BITCOIN_COMPACT_SIG_VERSION_RANGE.include? version
      errors.add(:signature, 'invalid signature')
    end
  rescue StandardError
    errors.add(:signature, 'wrong format')
  end
end

# == Schema Information
#
# Table name: secrets
#
#  id         :bigint(8)        not null, primary key
#  public_key :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  uuid       :string
#  sealed_at  :datetime
#  message    :text
#  signature  :string
#
