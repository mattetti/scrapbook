require 'tempfile'

class ToFile

  # Saves the passed content to a file.
  # @param [#to_s] content The content to save to file.
  # @param [String, NilClass] destination The path to save the content,
  # if none is passed, a tmpfile is used.
  # @return [String] The path of the file the content was saved to.
  def process(content, destination=nil)
    if destination
      file = File.open(destination, 'w'){|f| f << content}
    else
      file = Tempfile.new('scrapbook'){|f| f << content}
    end
    file.path
  end

end
