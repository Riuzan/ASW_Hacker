class User < ApplicationRecord
    has_many :contributions, dependent: :destroy
end
