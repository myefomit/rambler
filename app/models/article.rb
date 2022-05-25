class Article < ApplicationRecord
  has_many :tags

  validates :url, uniqueness: true

  scope :filter_ids, ->(ids) { where(id: ids) }
  scope :filter_title_contains, ->(substring) { where('title ILIKE ?', "%#{substring}%") }
end
