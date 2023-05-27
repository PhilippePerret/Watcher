module Watcher
class Backup
class << self

  ##
  # @main
  # 
  # Vérification des fichiers/dossiers et exécution
  # des backups.
  # 
  def exec
    puts "Je dois apprendre à watcher, c'est-à-idre".jaune
    puts "- voir si le dossier à surveiller existe (sinon finir)".jaune
    puts "- voir si toutes les destinations sont accessibles (sinon finir avec notification)".jaune
    puts "- voir si des fichiers/dossiers ont été modifiés aujourd'hui".jaune
    puts "- demander les chemins de destination qui ne sont pas définis".jaune
    puts "- enregistrer ces chemins si nécessaire".jaune
    puts "- procéder à l'actualisation".jaune
    puts "- enregistrer l'opération".jaune

    WatchedFolder.exist? || return

    puts "Oui, le dossier à surveiller existe.".vert

    #
    # On boucle sur chaque élément du dossier surveillé pour voir
    # s'il a été modifié aujourd'hui
    # 
    WatchedFolder.each_item do |item|
      puts "Check de #{item.inspect}"
      item.backup if item.modified?
    end

  end


  # @return [Time] Le temps de réference. Tout élément du dossier
  # surveillé qui a une date de modification supérieure doit être
  # backupé
  # 
  # TODO Pouvoir définir plus précisément (pour le moment, on prend
  # en référence le matin)
  def reference_time
    @reference_time ||= begin
      now = Time.now
      Time.new(now.year, now.month, now.day, 0,0,0)
    end
  end

end #/<< self Backup
end #/class Backup
end #/module Watcher
