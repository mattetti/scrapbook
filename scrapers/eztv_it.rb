require_relative 'utils'
require_relative 'interfaces'
require 'json'

module EzTV

  def self.run
    agent = Mechanize.new
    url = "http://eztv.it/sort/100/"
    page = agent.get(url)
    episodes = fetch_episodes(page)
    STDERR << "Error scraping #{url} - #{episodes.inspect}\n" if episodes.find{|e| e.failed?}
    episodes
  end

  def self.fetch_episodes(page)
    elements = page.search("table.forum_header_border tr.forum_header_border")
    episodes = elements.map do |e| 
      episode = Episode.new
      episode.url       = episode.fetch(e, "a.magnet", ->(el){ el.first.attributes['href'].value})
      episode.title     = episode.fetch(e, "a.epinfo", ->(el){ el.first.attributes["title"].value.strip})
      episode
    end
    episodes
  end

  class Episode
    include Scrapbook::Utils::Fetcher
    include EpisodeInterface

    def initialize
      @failures = []
    end

    def to_json
      hash = {}
      EpisodeInterface::ATTRIBUTES.each do |att|
        hash[att] = self.send(att)
      end
      hash.to_json
    end

  end
end

