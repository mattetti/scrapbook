require 'yaml'

# filters episodes based on a config file
module EpisodeFilter

  module_function

  def process(episodes, config_file=nil)
    if config_file.nil?
      episodes
    else
      config = YAML.load_file(config_file)
      keep_filter = config['keep']
      episodes.select{|e| match_filter?(keep_filter, e) } 
    end
  end

  def match_filter?(filter, episode)
    filter.any? do |f|
      getter = f.keys[0]
      value = f.values[0]
      episode.send(getter) =~ Regexp.new(value, 'i')
    end
  end

end
