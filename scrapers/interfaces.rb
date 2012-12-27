module EpisodeInterface
  ATTRIBUTES = [:show_name, :show_ref,
                  :title, :url, :image_url, :broadcast_date, :notes ]

  # Injects some accessors in the object including this module.  
  def self.included(base)
    base.send(:attr_accessor, *EpisodeInterface::ATTRIBUTES)
    base.send(:attr_reader, :failures)
  end

  def to_s
    "show: #{show_name} - show ref: #{show_ref} - title: #{title} - url: #{url} - notes: #{notes} - failures: #{self.failures.join("\n")}"
  end

  def failed?
    if self.url.nil? || (self.failures && !self.failures.empty?)
      true
    else
      false
    end
  end

end
