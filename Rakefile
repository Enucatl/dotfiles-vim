require 'rake'
require 'rake/clean'
require 'pathname'

SOURCE_FILES = Dir.glob(["bin/*", "dotfiles/*"]).select { |f| File.file?(f) }
SOURCE_FOLDERS = [
  "dotfiles/config/nvim",
]
SOURCES = SOURCE_FILES + SOURCE_FOLDERS
OUTPUT_FOLDER = ENV["HOME"]

def destination file_name
  if Pathname(file_name).each_filename.first == "bin"
    File.join(OUTPUT_FOLDER, file_name)
  elsif Pathname(file_name).each_filename.first == "dotfiles"
    File.join(OUTPUT_FOLDER, file_name.pathmap("%{^dotfiles/,.}p"))
  end
end

DEST_FILES = SOURCES.map{|f| destination f }
CLOBBER.include(DEST_FILES)

task :default => [:links]

desc "make the links in the home folder"
task :links => DEST_FILES

SOURCES.each do |source_file|
  destination_file = destination source_file
  file destination_file => source_file do
    mkdir_p destination_file.pathmap("%d")
    sh "ln -sb #{Pathname(source_file).realpath} #{destination_file}"
  end
end

BACKUP_ARCHIVE = File.join(OUTPUT_FOLDER, "dotfiles.vim.backup.tar")
file BACKUP_ARCHIVE do |f|
  sh "tar cf #{f.name} #{DEST_FILES.join(" ")}; true"
end

desc "backup any existing file that would be overwritten"
task :backup => BACKUP_ARCHIVE
