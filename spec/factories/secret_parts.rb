FactoryBot.define do
  factory :secret_part do
    secret
    sequence(:key) { |x| "key_#{x}" }
    encrypted_data "someencrypteddata"
  end
end
