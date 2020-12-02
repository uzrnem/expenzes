class Tag < ApplicationRecord
  has_many :activities
  belongs_to :transaction_type
end
