require 'rails_helper'

RSpec.describe Secret, type: :model do
  it "has a valid factory" do
    expect(build(:secret)).to be_valid
  end

  describe "associations" do
    it { is_expected.to have_many :parts }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of :public_key }
  end

  describe "uuid" do
    it "automatically generates a new uuid on creation" do
      expect(create(:secret).uuid).not_to eq create(:secret).uuid
    end
  end
end
