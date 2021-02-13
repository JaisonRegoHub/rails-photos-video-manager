class Favourite < ApplicationRecord
    belongs_to :attachment, optional: true
    belongs_to :user
end
