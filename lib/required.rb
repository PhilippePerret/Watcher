require 'clir'
require 'yaml'

APP_FOLDER = File.dirname(__dir__)

require_relative 'required/constants'
require_relative 'required/crontab'
require_relative 'required/webdav'
require_relative 'required/config'
require_relative 'required/backup'
require_relative 'required/watcher'
require_relative 'required/watched_folder'
require_relative 'required/watched_folder_item'
require_relative 'required/remote_item'
