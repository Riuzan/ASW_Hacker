class Contribution < ApplicationRecord
  belongs_to :user#, optional: true
  acts_as_votable
  validate do |contribution|
    contribution.errors.add("You must fill only the Url or the Text Fields", "") if contribution.url? and contribution.text?
  end
end
