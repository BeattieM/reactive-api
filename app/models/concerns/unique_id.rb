# Set a UUID on the associated model before model creation
module UniqueId
  extend ActiveSupport::Concern

  included do
    before_create :populate_uuid

    private

    def populate_uuid
      self.uuid = SecureRandom.uuid
    end
  end
end
