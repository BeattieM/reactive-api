require 'rails_helper'

describe V1::Posts::PostSerializer do
  it 'creates special JSON for the API' do
    post = FactoryGirl.create :post
    serializer = V1::Posts::PostSerializer.new post

    expect(data:[ActiveModelSerializers::Adapter.create(serializer).as_json[:data]]).to eql(
      data: [
        {
          id: post.uuid,
          type: "posts",
          attributes: {
            sprite: post.sprite,
            comment: post.comment,
            :"created-at" => post.created_at
          },
          relationships: {
            user: {
              data: {
                id: "#{post.user_id}",
                type: "users"
              }
            }
          }
        }
      ]
    )
  end
end
