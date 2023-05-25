##
# Gestion du crontab
# 
# Inspiré de : https://github.com/javan/whenever/blob/main/lib/whenever/command_line.rb
# 
# 
module Watcher
class Crontab


    ##
    # Lecture du crontab
    def read
      @current_crontab ||= begin
        command = [@options[:crontab_command]]
        command << '-l'
        command << "-u #{@options[:user]}" if @options[:user]
        command_results  = %x[#{command.join(' ')} 2> /dev/null]
        $?.exitstatus.zero? ? prepare(command_results) : ''
      end
    end

    ##
    # Écriture du crontab
    # 
    def write(contents)
      command = [@options[:crontab_command]]
      command << "-u #{@options[:user]}" if @options[:user]
      IO.popen(command.join(' '), 'r+') do |crontab|
        crontab.write(contents)
        crontab.close_write
      end

      success = $?.exitstatus.zero?

      if success
        action = 'written' if @options[:write]
        action = 'updated' if @options[:update]
        puts "[write] crontab file #{action}"
        exit(0)
      else
        warn "[fail] Couldn't write crontab; try running `whenever' with no options to ensure your schedule file is valid."
        exit(1)
      end
    end

    MARK_OPEN = '# Begin Watcher'.freeze
    REG_COMMENT_OPEN  = /^#{MARK_OPEN}$/.freeze
    MARK_CLOSE = '# End Watcher'.freeze
    REG_COMMENT_CLOSE = /^#{MARK_CLOSE}$/.freeze

    def updated
      # If an existing identifier block is found, replace it with the new cron entries
      if read =~ REG_COMMENT_OPEN && read =~ REG_COMMENT_CLOSE
        # If the existing crontab file contains backslashes they get lost going through gsub.
        # .gsub('\\', '\\\\\\') preserves them. Go figure.
        read.gsub(Regexp.new("^#{MARK_OPEN}$.+^#{MARK_CLOSE}$", Regexp::MULTILINE), whenever_cron.chomp.gsub('\\', '\\\\\\'))
      else # Otherwise, append the new cron entries after any existing ones
        [read, whenever_cron].join("\n\n")
      end.gsub(/\n{3,}/, "\n\n") # More than two newlines becomes just two.
    end


    def prepare(contents)
      # Strip n lines from the top of the file as specified by the :cut option.
      # Use split with a -1 limit option to ensure the join is able to rebuild
      # the file with all of the original seperators in-tact.
      stripped_contents = contents.split($/,-1)[@options[:cut]..-1].join($/)

      # Some cron implementations require all non-comment lines to be newline-
      # terminated. (issue #95) Strip all newlines and replace with the default
      # platform record seperator ($/)
      stripped_contents.gsub!(/\s+$/, $/)
    end

end #/class Crontab
end #/module Watcher
