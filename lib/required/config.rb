module Watcher
class Config
class << self

  def watched_folder
    @watched_folder ||= data[:watched_folder]
  end

  def data
    @data ||= begin
      if File.exist?(config_path)
        YAML.load_file(config_path, **YAML_OPTIONS)
      else
        {}
      end
    end
  end

  def config_path
    @config_path ||= File.join(APP_FOLDER,'config.yaml')
  end
end #/self
end #/class Config
end #/module Watcher
