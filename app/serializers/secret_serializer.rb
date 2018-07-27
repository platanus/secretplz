class SecretSerializer < ActiveModel::Serializer
  attributes :id, :public_key, :sealed_at, :parts

  def id
    object.uuid
  end

  def parts
    object.parts.to_a.map do |part|
      {
        key: part.key,
        encrypted_data: part.encrypted_data
      }
    end
  end
end
