require_relative 'utils'
require 'json'

module FranceTVJeunesse

  def self.run
    agent = Mechanize.new
    url = "http://pluzz.francetv.fr/ajax/launchsearch/rubrique/jeunesse/datedebut/#{Time.now.strftime("%Y-%m-%dT00:00")}/datefin/#{Time.now.strftime("%Y-%m-%dT23:59")}/type/lesplusrecents/nb/100/"
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
      episode
    end
    episodes
  end
  
  class Episode
    include Scrapbook::Utils::Fetcher

    ATTRIBUTES = [:show_name, :show_ref,
                  :title, :url, :image_url, :broadcast_date, :notes ]

    attr_accessor *ATTRIBUTES
    attr_reader :failures

    def initialize(opts=nil)
      @failures = []
      if opts.respond_to?(:keys) && opts.respond_to?(:each)
        opts.each do |k, v|
          self.send("#{k}=", v)
        end
      end
      self
    end

    def to_s
      "show: #{show_name} - show ref: #{show_ref} - title: #{title} - url: #{url} - notes: #{notes} - failures: #{self.failures.join("\n")}"
    end

    def to_json
      hash = {}
      ATTRIBUTES.each do |att|
        hash[att] = self.send(att)
      end
      hash.to_json
    end

    def failed?
      if self.url.nil? || self.failures.size > 3
        true
      else
        false
      end
    end

  end
end
