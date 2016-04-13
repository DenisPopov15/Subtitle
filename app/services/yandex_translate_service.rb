class YandexTranslateService

  YANDEX_MAX_TEXT_SIZE = 10000

  def initialize
    @translator = Yandex::Translator.new(Rails.application.secrets.yandex_translate_key)
    @from = "en"
    @to = "ru"
  end


  def translate(words)
    if !allowed_size?(words)
      if words.is_a?(String)
        words = words.split(" ")
      end
      requests = words.each_slice(YANDEX_MAX_TEXT_SIZE/20).to_a
      translate = []
      requests.each do |request|
        translated = fetch_translate(request)
        translate += translated
      end
    else
      translate = fetch_translate(words)
    end
    translate
  end


  protected

  def fetch_translate(words)
    if words.is_a?(String)
      translate = @translator.translate words, from: @from, to: @to
    else
      words = words.join(" |")
      translate = @translator.translate words, from: @from, to: @to
      translate = translate.split(" |")
    end
    translate
  end


  def allowed_size?(words)
    if words.is_a?(String)
      words.size < YANDEX_MAX_TEXT_SIZE
    else
      words.join(" |").size < YANDEX_MAX_TEXT_SIZE
    end
  end
end