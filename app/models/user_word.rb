class UserWord
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Search
  include Mongoid::Slug
  include Mongoid::Attributes::Dynamic
  include Ants::Id

  ## Attributes
  field :know, type: Boolean, default: true
  field :count, type: Integer, default: 0
  field :correct_answer, type: Integer, default: 0


  ## Relations
  belongs_to :word
  belongs_to :user


  ## Validations
  validates :word, presence: true


  ## Helpers

end
