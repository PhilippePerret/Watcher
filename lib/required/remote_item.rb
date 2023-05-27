module Watcher
class RemoteItem

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

  # @prop [Watcher::Webdav]
  def webdav_item
    @webdav_item ||= Webdav.get(watched_item.remote_path).tap do |i|
      puts "webdav item : #{i.inspect}"
    end
  end

  # Date de modification
  # 
  def mtime
    if self.defined?
      puts "webdav_item.mtime = #{webdav_item.mtime.inspect}"
      webdav_item.mtime
    else
      raise "L'élément distant est introuvable (remote path : #{watched_item.remote_path.inspect}"
    end
  end

end #/class RemoteItem
end #/module Watcher
