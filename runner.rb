require 'bundler'
Bundler.require
require 'fileutils'

STDOUT.sync = true

# Require all the scrapers & processors
Dir.glob("./scrapers/*.rb"){|file| require file }
Dir.glob("./processors/*.rb"){|file| require file }

FileUtils.mkdir_p('output')

#### FranceTV ###
## Scrap
#episodes = FranceTVJeunesse.run
## 1st processor
#filtered_episodes =  episodes #EpisodeFilter.process(episodes, "config/episode_filter.yml")
## 2nd processor
#summary = EpisodeSummary.process(filtered_episodes)
## 3rd processor
#destination = File.join(File.expand_path(File.dirname(__FILE__)), "output", "francetv_summary_#{Time.now.strftime("%Y-%m-%d")}.html")
#puts ToFile.process(summary, destination)

#### eztv.it ###
## Scrap
#episodes = EzTV.run
#summary = EpisodeSummary.process(episodes)
## 3rd processor
#destination = File.join(File.expand_path(File.dirname(__FILE__)), "output", "eztv_summary_#{Time.now.strftime("%Y-%m-%d")}.html")
#puts ToFile.process(summary, destination)

# mixed summary
episodes = FranceTVJeunesse.run + EzTV.run
summary = EpisodeSummary.process(episodes)
destination = File.join(File.expand_path(File.dirname(__FILE__)), "output", "summary_#{Time.now.strftime("%Y-%m-%d")}.html")
`open #{ToFile.process(summary, destination)}`
