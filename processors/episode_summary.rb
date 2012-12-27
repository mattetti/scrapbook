# Creates a formatted summary of a collection of episodes.
#
class EpisodeSummary

  attr_accessor :items

  # Converts the passed episode items in a summary
  # that is formatted based on the passed format.
  # @param [Array<#title>] items The episodes to summarize
  # @param [Symbol] format The summary format (:html and :json
  # supported)
  # @return [String]
  def process(items, format=:html)
    self.items = items
    if format == :html
      html_header + "\n" + \
      items.map{|i| html_episode_summary(i)}.join("\n") + \
      html_footer
    elsif format == :json
      items.map(&:to_json)
    else
     "Format #{format} not supported"
    end
  end

  def html_header
    <<-EOS
    <!DOCTYPE html>
    <html>
    <head><meta charset="utf-8"></head>
    <body>
    <div>
      <h1>List of episodes</h1>
      <ul>      
    EOS
  end

  def html_footer
    "</ul></div></body></html>"
  end

  def html_episode_summary(item)
    <<-EOS
      <li>
        <h2>#{item.show_name} - #{item.title}</h2>
        <a href="#{item.url}">Link (#{item.notes})</a>
      </li>
    EOS
  end

end
