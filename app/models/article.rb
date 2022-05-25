class Article < ApplicationRecord
  scope :filter_ids, ->(ids) { where(id: ids) }
  scope :title_contains, ->(substring) { where('title LIKE ?', "%#{substring}%") }
end
