require 'rails_helper'

RSpec.describe Secret, type: :model do
  it "has a valid factory" do
    expect(build(:secret)).to be_valid
  end

  subject(:secret) { create(:secret) }

  describe "associations" do
    it { is_expected.to have_many :parts }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :public_key }

    let(:valid_signature) do
      'H14wy79iaR30kfvhnUQhjLXH6Vd/KAoYQ7TkKKT41Fk1EkikmtYdddD47TbkeunjfNNyVJxx/jXFY4I17jv72GE='
    end

    let(:invalid_signature) do
      'H5VxXHJcJj+PswBfkXu8InBmA5C46VJ5l9dlRi56Vi774W3FRBA/IrwmlHSKSwouALySDg1C0WkIdP3CpIgDiQ=='
    end

    let(:invalid_signature_version) do
      'G5VxXHJcJj+PswBfkXu8InBmA5C46VJ5l9dlRi56Vi774W3FRBA/IrwmlHSKSwouALySDg1C0WkIdP3CpIgDiQU='
    end

    it "validates a given signature has the right length and version" do
      expect(build(:secret, signature: valid_signature).valid?).to be true
      expect(build(:secret, signature: invalid_signature).valid?).to be false
      expect(build(:secret, signature: invalid_signature_version).valid?).to be false
    end
  end

  describe "uuid" do
    it "automatically generates a new uuid on creation" do
      expect(create(:secret).uuid).not_to eq create(:secret).uuid
    end
  end

  describe "seal!" do
    it "sets the sealed_at timestamp" do
      expect { secret.seal! }.to change { secret.reload.sealed_at }.from nil
    end

    it "can only be sealed once" do
      secret.seal!

      expect { secret.seal! }.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
