module Watcher
class WatchedFolderClass
class Item

  attr_reader :watched_folder, :path

  def initialize(watched_folder, path)
    @path   = path
    @watched_folder = watched_folder
  end

  def inspect
    @inspect ||= "#<WatchedFolder::Item .#{relpath}>"
  end

  ##
  # Procède au backup de l'élément
  # 
  def backup
    puts "Je dois apprendre à backuper #{path.inspect}".jaune
  end

  # @return true si l'item (fichier ou dossier) a été modifié
  # 
  def modified?
    puts "mtime = #{mtime}"
    mtime > remote_item.mtime
  end

  def directory?
    File.directory?(path)
  end

  # @return [Time] Date de dernière modification
  def mtime
    if directory?
      mt = Time.new(2000,1,1)
      Dir["#{path}/**/*.*"].each do |f|
        fmtime = File.stat(f).mtime
        mt = fmtime if fmtime > mt
      end
      return mt
    else
      File.stat(path).mtime
    end
  end

  # @return [RemoteItem] Le fichier miroir distant
  def remote_item
    @remote_item ||= RemoteItem.new(self)
  end

  # @return [String] Le chemin d'accès (relatif) à cet élément
  # 
  # @note
  #   Il peut ne pas être encore défini
  def remote_path
    @remote_path ||= begin
      f = File.join(folder, ".#{affixe}")
      unless File.exist?(f)
        rpath = Q.ask("Quel est le chemin relatif de l'élément '#{affixe}' (à partir de #{Webdav.base})".jaune) || return
        rpath = rpath.strip
        File.write(f, rpath)
      end
      File.read(f).strip
    end
  end

  def relpath
    @relpath ||= path.sub(/^#{watched_folder.path}/,'')
  end

  def folder
    @folder ||= File.dirname(path)
  end
  def affixe
    @affixe ||= File.basename(path,File.extname(path))
  end

end #/class Item
end #/class WatchedFolderClass
end #/module Watcher
