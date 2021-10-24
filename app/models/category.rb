# frozen_string_literal: true

class Category < ApplicationRecord
  scope :visible, -> { where(visible: true) }
end
