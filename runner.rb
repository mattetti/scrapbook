require 'bundler'
Bundler.require
require 'fileutils'

STDOUT.sync = true

# Require all the scrapers
Dir.glob("./scrapers/*.rb"){|file| require file }
Dir.glob("./processors/*.rb"){|file| require file }

FileUtils.mkdir_p('output')
# TODO: use a scheduler and send to processors
episodes = FranceTVJeunesse.run
summary = EpisodeSummary.new.process(episodes)
destination = File.join(File.expand_path(File.dirname(__FILE__)), "output", "summary_#{Time.now.strftime("%Y-%m-%d")}.html")
puts ToFile.new.process(summary, destination)
