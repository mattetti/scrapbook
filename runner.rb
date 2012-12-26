require 'bundler'
Bundler.require

# Require all the scrapers
Dir.glob("./scrapers/*.rb"){|file| require file }

# TODO: use a scheduler and send to processors
episodes = FranceTVJeunesse.run
puts episodes.map(&:to_json)
