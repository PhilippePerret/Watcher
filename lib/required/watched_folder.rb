module Watcher
class WatchedFolderClass

  attr_reader :path

  def initialize(path)
    @path = path || 'none'
  end

  def exist?
    File.exist?(path)
  end

  ##
  # Boucle sur chaque élément du dossier à surveiller
  # 
  def each_item &block
    items.each do |item|
      yield item
    end
  end

  def items
    @items ||= begin
      Dir["#{path}/*"].map { |p| WatchedFolderClass::Item.new(self, p) }
    end
  end

end #/class WatchedFolder

WatchedFolder = WatchedFolderClass.new(Config.watched_folder)

end #/module Watcher
