class Article < ApplicationRecord
  belongs_to :category
  belongs_to :user

  has_one_attached :photo
  has_many_attached :images
  has_one_attached :video

  enum status: { draft: 0, pending: 1, published: 2, archived: 3 }
  
  # Scopes for easier querying
  scope :drafts, -> { where(status: :draft) }
  scope :pending_review, -> { where(status: :pending) }
end
