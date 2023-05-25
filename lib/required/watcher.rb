module Watcher

  # @main
  # @entry
  # 
  # Point d'entrée du programme
  def self.run
    case CLI.main_command
    when 'help', 'aide'
      puts "Je dois apprendre à afficher l'aide.".jaune
    else
      #
      # <= No command
      # => Obviously run watcher
      # 
      watch_and_backup
    end
  rescue TTY::Reader::InputInterrupt
    # Abandon silencieux
    puts ""
  rescue Exception => e
    puts e.message.rouge
    puts e.backtrace.join("\n").rouge
  end

  ##
  # @main
  # 
  # Méthode procédant au backup si nécessaire
  # 
  def self.watch_and_backup
    Watcher::Backup.exec
  end
end #/module Watcher
