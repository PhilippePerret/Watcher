# require_relative 'lib/required'
# # require 'osx/cocoa'

# Dir["#{Watcher::Config.watched_folder}/*"].each do |fpath|
  
# end
=begin
Net::DAV.start("https://localhost.localdomain/xyz/") do |dav|
  dav.find('.', :recursive => true) do |item|
    item.content = item.content.gsub(/silly/i, 'funny')
  end
end
=end
require 'yaml'
require 'time'
SECRET_DATA = YAML.load_file(File.join(Dir.home,'.secret/comptes.yaml'),**{symbolize_names:true})
IONOS_USER = SECRET_DATA[:ionos][:usr]
IONOS_PASS = SECRET_DATA[:ionos][:pwd]
IONOS_WEBD = SECRET_DATA[:ionos][:dav]

location = IONOS_WEBD
sub_location = "users/#{IONOS_USER}"
require 'net/dav'
dav = Net::DAV.new(File.join(location,sub_location))
dav.credentials(IONOS_USER, IONOS_PASS)
dav.start do |dav|
  puts "dav.exists?('babar') -> #{dav.exists?('babar').inspect}"
  puts "dav.exists?(#{IONOS_USER}) -> #{dav.exists?(IONOS_USER).inspect}"
  dav.find('.', :recursive => false) do |item|
    puts "item: #{item.inspect}"
    puts "item.type = #{item.type}"
    puts "item.url  = #{item.url}"
    puts "item.uri  = #{item.uri}"
    puts "item.size = #{item.size}"
    puts "item.content= 'nouveau contenu'" # si fichier
    puts "item.properties.lastmodificationdate = #{item.properties.lastmodificationdate.inspect}"
    dav.cd(item.url)
    puts "dav.exists?('AIDES') -> #{dav.exists?('AIDES').inspect}"
  end
end
# Méthodes de dav
# dav.copy(src, dest)
# dav.move(src, dest)
# dav.delete(path)
# dav.put_string(path, str) # écrit du texte dans un fichier
# dav.get(path, &block) # contenu d'un fichier
# dav.cd(path) 
# dav.find(path, **{filename => /\.html/, suppress_errors: true})
