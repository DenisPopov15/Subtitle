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


  ## Scopes
  scope :known, -> { where(know: true) }
  scope :unknown, -> { where(know: false) }


  ## Helpers
  def self.create_words_and_attach_to_user(words)
    words = words.map { |word|
      { eng: word[:eng],
        rus: word[:rus],
        user_words_attributes: [ { know: word[:know], user: current_user } ]
      }
    }

    Word.create(words)
  end


  def self.add_words_to_user(words_array)
    eng_words = words_array.map { |word| word[:eng] }
    words     = Word.in(eng: eng_words)

    present_words = UserWord.in(word: words)
    # present_words.update_all({count: :count + 1})
    present_words = present_words.map { |p_w| p_w.eng }
    present_words = words_array.select {|word| present_words.include?(word[:eng]) }

    words_array   = words_array - present_words

    # current_user = User.first
    words = words_array.each_with_index.map { |word, i|
      { user: current_user,
        know: word[:know],
        word: words[i],
        count: 1,
      }
    }

    UserWord.create(words)
  end
end

