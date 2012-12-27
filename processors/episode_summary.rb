# Creates a formatted summary of a collection of episodes.
#
module EpisodeSummary

  module_function

  # Converts the passed episode items in a summary
  # that is formatted based on the passed format.
  # @param [Array<#title>] items The episodes to summarize
  # @param [Symbol] format The summary format (:html and :json
  # supported)
  # @return [String]
  def process(items, format=:html)
    if format == :html
      output = html_header + "\n"
      output += sorted_summaries(items, :show_name, :title).join("\n")
      output += html_footer
      output
    elsif format == :json
      items.map(&:to_json)
    else
     "Format #{format} not supported"
    end
  end

  def sorted_summaries(items, by_attribute, fallback=nil)
    fallback_value = ->(item){ fallback ? item.send(fallback).to_s : 'zzzzzzzz' }
    sorted = items.sort do |a,b| 
      (a.show_name || fallback_value.call(a)) <=> (b.show_name || fallback_value.call(b))
    end
    sorted.map{|i| html_episode_summary(i) }
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
        #{("<div><img href='#{item.url}' 
                 src='" + item.image_url + 
                "' /img></div>") if item.image_url}
        <a href="#{item.url}">
          #{(item.notes.nil? || item.notes == "") ? 'link' : item.notes }
        </a> 
        #{("<span> Show ref: " + item.show_ref + "</span>") if item.show_ref}
      </li>
    EOS
  end

end
