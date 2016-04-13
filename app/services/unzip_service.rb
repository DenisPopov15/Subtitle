class UnzipService
  require 'zipruby'

  def initialize
  end

  def self.unzip(url, file_name)
    file_name = file_name.gsub(" ", "_")
    unzipped = []
    # url = "http://subscene.com#{link}"
    data = { "some-bizarre-params" => "which-are-needed" }
    zipbytes = Net::HTTP.post_form(URI.parse(url), data).body
    Zip::Archive.open_buffer(zipbytes) do |zf|
      # this is a single file archive, so read the first file
      zip = zf.fopen(zf.get_name(0)) do |f|
        unzipped = f.read
      end
      file = File.new("public/uploads/subtitles/#{file_name}.srt", 'w')

      # unzipped = encode(unzipped)
      unzipped = unzipped.force_encoding('UTF-8')
      file.puts(unzipped)
      file.close
    end

  end


  private

  def encode(f)
    begin
    decode = f.force_encoding('UTF-8')
    unless decode.valid_encoding?
    decode = decode.encode( 'UTF-8', 'Windows-1251' )
    end
    content = decode
    rescue EncodingError
      content.encode!( 'UTF-8', invalid: :replace, undef: :replace )
    end
    decode
  end


end
