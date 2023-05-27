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
      File.stat(path).mtime > remote_file.mtime
    end  
  end

  def directory?
    File.directory?(path)
  end

  # @return [RemoteFile] Le fichier miroir distant
  def remote_file
    @remote_file ||= RemoteFile.new(self)
  end

  # @return [String] Le chemin d'accès (relatif) à cet élément
  # 
  # @note
  #   Il peut ne pas être encore défini
  def remote_path
    @remote_path ||= begin
      f = File.join(folder, ".#{affixe}")
      if File.exist?(f)
        File.read(f)
      else
        rpath = Q.ask("Quel est le chemin relatif de l'élément '#{affixe}' (à partir de #{Webdav.base})".jaune) || return
        File.write(f, rpath.strip)
      end
    end
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
