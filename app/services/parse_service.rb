class ParseService
  def self.parse(source)
    parsed_words = []
    source.each do |line|
      line = line.gsub(/[^a-zA-Z \]`]/,"").gsub(/(adv|prep|pron|int)/, "")
      words = line.split(' ')
      words.each do |word|

        doubleword = word.scan("`").size
        doubleword1 = word.scan("'").size
        vocab = word.scan("]").size
        www = word.scan("www").size
        http = word.scan("http").size

        if doubleword == 0 && doubleword1 == 0 && vocab == 0 && www == 0 && http == 0 && word.size > 3
           parsed_words.push(word)
           parsed_words = parsed_words.uniq
         end

      end
    end
    parsed_words
  end

end
