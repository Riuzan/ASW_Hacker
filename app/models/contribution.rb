class Contribution < ApplicationRecord
  belongs_to :user, optional: true
  validate do |contribution|
    contribution.errors.add("You must fill only the Url or the Text Fields", "") if contribution.url? and contribution.text?
  end
end
