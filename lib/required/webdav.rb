require 'net/dav'
require 'time'

module Watcher
class Webdav
class << self

  def get(relpath)
    dirname   = File.dirname(relpath)
    basename  = File.basename(relpath)
    dav = Net::DAV.new(File.join(ionos_webdav, ionos_user))
    dav.credentials(ionos_user, ionos_password)
    if dav.exists?(dirname)
      dav.find(dirname, **{filename:basename, recursive: false}) do |item|
        return item
      end
    else
      nil
    end
  end

  def base
    @base ||= File.join('users',ionos_user)
  end

  def ionos_user
    @ionos_user ||= secret_data[:usr]    
  end

  def ionos_password
    @ionos_password ||= secret_data[:pwd]
  end

  def ionos_webdav
    @ionos_webdav ||= secret_data[:dav]
  end

  def secret_data
    @secret_data ||= begin
      YAML.load_file(File.join(Dir.home,'.secret/comptes.yaml'),**{symbolize_names:true})
    end
  end
end #/<< self Webdav

###################       INSTANCE      ###################

  def initialize(relpath)
    @relpath = relpath
  end


end #/class Webdav
end #/module Watcher
