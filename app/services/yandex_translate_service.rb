class YandexTranslateService
  def initialize
    @translator = Yandex::Translator.new(Rails.application.secrets.yandex_translate_key)
    @from = "en"
    @to = "ru"
  end

  def translate(words)
    if words.is_a?(String)
      translate = @translator.translate words, from: @from, to: @to
    else
      translate = @translator.translate words.join(" |"), from: @from, to: @to
      translate = translate.split(" |")
    end
    translate
  end
end