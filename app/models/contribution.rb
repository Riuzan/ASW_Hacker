class Contribution < ApplicationRecord
  belongs_to :user
  has_one :comment, :class_name => 'Contribution'
  validates :user_id, presence: true
end
