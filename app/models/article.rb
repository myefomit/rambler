class Article < ApplicationRecord
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags

  validates :url, uniqueness: true

  scope :filter_ids, ->(ids) { where(id: ids) }
  scope :filter_title_contains, ->(substring) { where('title ILIKE ?', "%#{substring}%") }
end
