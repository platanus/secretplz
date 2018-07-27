require 'rails_helper'

RSpec.describe SecretPart, type: :model do
  it "has a valid factory" do
    expect(build(:secret_part)).to be_valid
  end

  describe "associations" do
    it { is_expected.to belong_to :secret }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :secret }
    it { is_expected.to validate_presence_of :encrypted_data }
    it { is_expected.to validate_uniqueness_of(:key).scoped_to(:secret_id) }
    it { is_expected.to allow_value(nil).for(:key) }

    it "validates that secret is not sealed" do
      secret = create(:secret)
      expect(build(:secret_part, secret: secret)).to be_valid
      secret.seal!
      expect(build(:secret_part, secret: secret)).not_to be_valid
    end
  end
end
