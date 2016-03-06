class SubtitlesController < ApplicationController
  before_filter :authenticate_all_user!

  def index
  end

  def show
  end

  def edit
  end

  def create
    uploaded_io = params[:subtitle]
    File.open(Rails.root.join('public', 'uploads', 'subtitle.srt'), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    file = File.new('public/uploads/subtitle.srt')
    parsed_words = ParseService.parse(file)
    user_words = current_user.words.map {|u_w| u_w.word.eng }
    new_words = fetch_unic_words(user_words, parsed_words)
    translated_words = TranslateService.new.translate(new_words)
    words = generate_words_with_translate(new_words, translated_words)

  end

  def update
  end

  def destroy
  end

  private

  def generate_words_with_translate(original, translate)
    words = []
    new_words.each_with_index do |eng, index|
      words.push( { eng: eng, rus: translated_words[index] } )
    end
    words
  end


  def fetch_unic_words(bd_words, new_words)
    unic_words = []
    new_words.each do |word|
      unless bd_words.include?(word) || bd_words.include?(word[0..-2]) || bd_words.include?(word[0..-3])
        unic_words.push(word)
      end
    end
    unic_words
  end

end
