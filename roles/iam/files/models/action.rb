class Action < ApplicationRecord
  belongs_to :service
end
class ReadAction < Action
end
