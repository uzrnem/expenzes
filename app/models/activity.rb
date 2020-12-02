class Activity < ApplicationRecord
  belongs_to :from_account, :class_name => 'Account', :optional => true
  belongs_to :to_account, :class_name => 'Account', :optional => true
  belongs_to :tag
  has_many :passbooks
  belongs_to :transaction_type
end
