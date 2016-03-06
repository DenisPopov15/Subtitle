class Subtitle
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Slug
  include Mongoid::Attributes::Dynamic
  include Ants::Id

  ## Attributes
  field :title
  field :link
  field :words_count, type: Integer, default: 0
  # field :image

  # Uploaders
  mount_uploader :image, SubtitleImageUploader


  ## Relations
  has_many :words


  ## Callbacks
  # after_validation :update_rating


  ## Search
  search_in :title


  ## Validations
  validates :title, presence: true


  ## Helpers

end
