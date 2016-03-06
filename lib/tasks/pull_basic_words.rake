namespace :seed do
  desc "Pull start levels words to DB"
  task :pull_basic_words => :environment do
    db300 = File.new(File.join(Rails.root, 'db', 'vocabularies', 'db300.srt'))
    db500 = File.new(File.join(Rails.root, 'db', 'vocabularies', 'db500.srt'))
    db1000 = File.new(File.join(Rails.root, 'db', 'vocabularies', 'db1000.srt'))
    db2500 = File.new(File.join(Rails.root, 'db', 'vocabularies', 'db2500.srt'))

    vocabularies = [db300, db500, db1000, db2500]

    words_for_db = []

    vocabularies.each do |vocabulary|
      vocabulary.each do |line|
        line = line.gsub(/[^a-zA-Z \]`]/,"").gsub(/(adv|prep|pron|int)/, "")
        words = line.split(' ')
        words.each do |word|

          doubleword = word.scan("`").size
          doubleword1 = word.scan("'").size
          vocab = word.scan("]").size
          www = word.scan("www").size
          http = word.scan("http").size

          if doubleword == 0 && doubleword1 == 0 && vocab == 0 && www == 0 && http == 0 && word.size > 3
             words_for_db.push(word)
             words_for_db = words_for_db.uniq
           end

        end
      end
    end
    translated_words = []
    # Limit for Yandex translate request - 10000 characters
    words_for_db.each_slice(900).to_a.each do |chunk_words|
      translated_words += TranslateService.new.translate(chunk_words)
    end

    words = []
    words_for_db.each_with_index do |eng, index|
      words.push( { eng: eng, rus: translated_words[index] } )
    end
    Word.create!(words)

  end
end
