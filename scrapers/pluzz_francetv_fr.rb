require_relative 'utils'
require_relative 'interfaces'
require 'json'
require 'date'

module FranceTVJeunesse

  def self.run
    agent = Mechanize.new
    url = "http://pluzz.francetv.fr/ajax/launchsearch/rubrique/jeunesse/datedebut/#{(Date.today - 1).strftime("%Y-%m-%dT00:00")}/datefin/#{Date.today.strftime("%Y-%m-%dT23:59")}/type/lesplusrecents/nb/200/"
    page = agent.get(url)
    episodes = fetch_episodes(page)
    STDERR << "Error scraping #{url}" if episodes.find{|e| e.failed?}
    episodes
  end

  def self.fetch_episodes(page)
    elements = page.search("article.rs-cell")
    episodes = elements.map do |e| 
      episode = Episode.new
      episode.url       = episode.fetch(e, "h3 > a", ->(el){ el.first.attributes["href"].value})
      episode.show_name = episode.fetch(e, "h3 > a", ->(el){ el.first.text.strip})
      episode.show_ref  = episode.fetch(e, "span[data-prog]", ->(el){ el.first.attributes['data-prog'].value})
      episode.title     = episode.fetch(e, "div.rs-cell-details", ->(el){ el.first.search("a.ss-titre").text.strip})
      episode.notes     = episode.fetch(e, "div.rs-cell-details", ->(el){ el.first.search("a.rs-ep-ss").text.strip})
      episode.image_url = episode.fetch(e, "figure.rs-cell-image img", ->(el){ el.first.attributes["src"].value})
      episode
    end
    episodes
  end

  class Episode
    include Scrapbook::Utils::Fetcher
    include EpisodeInterface

    def initialize(opts=nil)
      @failures = []
      if opts.respond_to?(:keys) && opts.respond_to?(:each)
        opts.each do |k, v|
          self.send("#{k}=", v)
        end
      end
      self
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
