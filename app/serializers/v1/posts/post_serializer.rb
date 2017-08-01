# Creates serialized output (JSON) for a Post
class V1::Posts::PostSerializer < ActiveModel::Serializer
  attributes :id, :sprite, :comment, :created_at
  belongs_to :user

  def id
    @object.uuid
  end
end
