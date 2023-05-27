require 'net/dav'
require 'time'

module Watcher
class Webdav
class << self

  def get(relpath)
    relpath = URI::Parser.new.escape(relpath)
    dirname   = File.dirname(relpath)
    basename  = File.basename(relpath)
    uri = File.join(ionos_webdav, 'users', ionos_user)
    netdav = Net::DAV.new(uri)
    netdav.credentials(ionos_user, ionos_password)
    netdav.start do |dav|
      dirname = "#{ionos_user}/#{dirname}"
      if dav.exists?(dirname)
        @webdav_item = nil
        dav.find(dirname, **{recursive: false}) do |item|
          if item.url.to_s.match?(basename)
            @webdav_item = item
            break
          end
        end
        @webdav_item || raise("Impossible de trouver #{relpath.inspect}")
        new(@webdav_item)
      else
        puts "#{dirname} n'existe pas".orange
        puts "Ce qui existe :"
        dav.find('./philippeperret', **{recursive:false}) do |item|
          puts "item #{item.url}"
        end
        nil
      end
    end
  end

  def get_mtime_from(dir_path)
    dav = Net::DAV.new(File.join(ionos_webdav, ionos_user))
    dav.credentials(ionos_user, ionos_password)
    #
    # Chemin absolu
    # 
    dir_path = File.join(ionos_webdav, ionos_user, dir_path)
    dav.exists?(dir_path) || raise("Élément inconnu (#{dir_path})")
    max_mtime = Time.new(2000,1,1)
    dav.find(dir_path, **{recursive: true}) do |item|
      # On ne prend que les fichiers
      next if item.directory?
      item_mtime  = item.properties.lastmodificationdate
      max_mtime   = item_mtime if item_mtime > max_mtime
    end
    return max_mtime
  end

  def base
    @base ||= File.join('users', ionos_user)
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
      YAML.load_file(File.join(Dir.home,'.secret/comptes.yaml'),**{symbolize_names:true})[:ionos]
    end
  end
end #/<< self Webdav

###################       INSTANCE      ###################

  attr_reader :dav_item

  def initialize(dav_item)
    @dav_item = dav_item
  end

  def directory?
    :TRUE == @isdir ||= true_or_false(dav_item.type == 'directory')
  end

  def mtime
    if directory?
      self.class.get_mtime_from(dav_item.url)
    else
      dav_item.properties.lastmodificationdate
    end
  end

end #/class Webdav
end #/module Watcher
