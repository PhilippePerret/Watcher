module Watcher
class RemoteFile

  # [WatchedFolder::Item] item Fichier/dossier surveillé
  attr_reader :watched_item

  # @param [WatchedFolder::Item] item Fichier/dossier surveillé
  def initialize(item)
    @watched_item = item
  end

  # @return true si le chemin d'accès à ce fichier est défini
  def defined?
    not(webdav_item.nil?)
  end

  def webdav_item
    @webdav_item ||= Webdav.get(watched_item.remote_path)
  end

  # Date de modification
  # 
  def mtime
    if defined?
      webdav_item.properties.lastmodificationdate
    else
      raise "L'élément distant est introuvable (remote path : #{watched_item.remote_path.inspect}"
    end
  end

end #/class RemoteFile
end #/module Watcher
