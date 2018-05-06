class Contribution < ApplicationRecord
  has_many :comments, as: :commentable
  belongs_to :user
  validates :url, uniqueness: true
  acts_as_votable
  validate do |contribution|
    contribution.errors.add("You must fill only the Url or the Text Fields", "") if contribution.url? and contribution.text?
  end
end
