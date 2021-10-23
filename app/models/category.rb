class Category < ApplicationRecord
    scope :visible, -> { where(visible: true) }
end
