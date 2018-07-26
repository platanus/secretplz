FactoryBot.define do
  factory :secret do
    public_key "03e16c894be569eb6b3e56c11d66cdbc32b43ffb673b371b42d918e99c228f3f8a"

    trait :with_parts do
      after(:build) do |secret|
        create(:secret_part, secret: secret)
        create(:secret_part, secret: secret)
        create(:secret_part, secret: secret)
      end
    end
  end
end
