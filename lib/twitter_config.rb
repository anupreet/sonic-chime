module TwitterConfig
  extend self


  def [](key)
    config_file[key]
  end

  def config_file
    @config_file ||= begin
      file = Rails.root.join('config', 'twitter.yml')
      yaml = ERB.new(File.read(file)).result(binding)
      YAML.load(yaml)[Rails.env] || {}
    end
  end

end