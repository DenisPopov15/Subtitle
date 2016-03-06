class TranslateService
  def initialize
    @translate_service = YandexTranslateService.new
  end

  def translate(words)
    @translate_service.translate(words)
  end
 end
