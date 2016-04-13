class Word
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Slug
  # include Mongoid::Attributes::Dynamic
  include Ants::Id

  ## Attributes
  field :eng
  field :rus


  ## Relations
  # has_many :subtitles
  has_many :user_words
  accepts_nested_attributes_for :user_words

  ## Callbacks
  # after_validation :update_rating

  ## Search
  search_in :eng

  ## Validations
  validates_uniqueness_of :eng, message: 'This Word already exist in DB'

  ## Indexes
  # index({ created_at: -1 })

  ## Helpers
  def self.preintermidiate
    all[0..272]
  end

  def self.intermidiate
    all[0..512]
  end

  def self.upperintermidiate
    all[0..1044]
  end

  def self.advanced
    all[0..2610]
  end

end
