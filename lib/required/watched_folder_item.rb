module Watcher
class WatchedFolderClass
class Item

  attr_reader :folder, :path

  def initialize(watched_folder, path)
    @path   = path
    @folder = watched_folder
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
    if directory?
    else
      File.stat(path).mtime > Backup.reference_time
    end  
  end

  def directory?
    File.directory?(path)
  end


end #/class Item
end #/class WatchedFolderClass
end #/module Watcher
