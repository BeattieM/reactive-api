# A message shared by a User
class Post < ApplicationRecord
  include UniqueId
  acts_as_paranoid

  belongs_to :user
  belongs_to :pokemon

  delegate :sprite, to: :pokemon

  validates :comment, length: { maximum: 140 }
end
