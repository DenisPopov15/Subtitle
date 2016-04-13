class UserWordsController < ApplicationController
  before_filter :authenticate_user!

  def index
  end

  def show
  end

  def edit
  end

  def new
    uploaded_io = params[:subtitle]
    File.open(Rails.root.join('public', 'uploads', 'subtitle.srt'), 'wb') do |file|
      file.write(uploaded_io.read)
    end
    # TODO -> Add SecureRandom.hex(16) to file_name and delete files after process
    file = File.new('public/uploads/subtitle.srt')
    parsed_words = ParseService.parse(file)
    user_words = current_user.words.known.map {|u_w| u_w.word.eng }
    new_words = fetch_unic_words(user_words, parsed_words)
    translated_words = TranslateService.new.translate(new_words)
    @words = generate_words_with_translate(new_words, translated_words)

    # file_before = IO.read('public/uploads/subtitle.srt')
  end

  # Need pass words
  def generate_updated_file
    original_file = IO.read('public/uploads/subtitle.srt')
    updated_file = File.new('public/uploads/updated_subtitle.srt', 'w')

    words.each do |word|
      original_file = original_file.gsub(/( #{word[:eng]} | #{word[:eng]},| #{word[:eng]}.)/,"<font color=#00FF00> #{word[:eng]} : #{word[:rus]} </font>")
    end
    updated_file.puts("#{original_file}")
    updated_file.close
    send_file('public/uploads/updated_subtitle.srt', type: 'text/srt')
  end

  def create
    ap params

    render 'index'
    # # words = params[:words]
    # # selected_words = params[:words].cheked
    # selected_words = selected_words.map {|u_w| u_w[:know] = true }
    # not_selected_words = words - selected_words
    # not_selected_words = not_selected_words.map {|word| word[:know] = false }
    # words = selected_words + not_selected_words

    # bd_words = Words.all.map {|w| w.eng}
    # new_words = words.map {|w| w[:eng] }
    # words_to_bd = fetch_unic_words(bd_words, new_words)
    # # words_for_create it is words_to_bd, but with full hash (not only :eng)
    # words_for_create = words.select {|word| words_to_bd.include?(word[:eng]) }
    # words_for_update = words - words_for_create

    # UserWord.create_words_and_attach_to_user(words_for_create)
    # UserWord.add_words_to_user(words_for_update)
  end

  def update
  end

  def destroy
  end


  private


  def generate_words_with_translate(original, translate)
    words = []
    original.each_with_index do |eng, index|
      words.push( { eng: eng, rus: translate[index] } )
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
