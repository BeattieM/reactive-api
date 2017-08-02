# A stored entry from the Pokemon API
class Pokemon < ApplicationRecord
  self.table_name = 'pokemon'

  has_many :posts
end
