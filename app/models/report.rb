# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :category

  scope :with_visible_categories, -> { includes(:category).where(category: { visible: true }) }
  scope :within_range, ->(range) { where(date: range) }
  scope :grouped, -> { group(:name).group_by_month(:date) }
end
