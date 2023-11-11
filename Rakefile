# Defining Source Files and Folders: It identifies the files and folders to
#   be linked or handled specially.
# Defining Destination: The destination method determines where each source
#   file should be linked in the home folder.
# Default Task and Links Task: The default task is to create symbolic links,
#   and the :links task is defined to create links for all destination files.
# Individual Source File Tasks: A task is defined for each source file to
#   create symbolic links in the home folder.
# Backup Task: It creates a tar archive of existing dotfiles for backup
#   before linking new files.
# Cleanup: The CLOBBER list includes destination files for cleanup.

require 'rake'
require 'rake/clean'
require 'pathname'

# Define the source files by globbing bin and dotfiles directories.
SOURCE_FILES = Dir.glob(["bin/*", "dotfiles/*"]).select { |f| File.file?(f) }
# Define source folders that need special handling.
SOURCE_FOLDERS = [
  "dotfiles/config/lvim",
]
# Combine source files and folders into a single array.
SOURCES = SOURCE_FILES + SOURCE_FOLDERS
# Define the output folder as the user's home directory.
OUTPUT_FOLDER = ENV["HOME"]

# Define a method to determine the destination of a file based on its type.
# files in the bin folder are linked to ~/bin
# files in the dotfiles folder are linked to ~ and prefixed with a dot .
# example: dotfiles/bashrc -> ~/.bashrc
def destination file_name
  if Pathname(file_name).each_filename.first == "bin"
    File.join(OUTPUT_FOLDER, file_name)
  elsif Pathname(file_name).each_filename.first == "dotfiles"
    File.join(OUTPUT_FOLDER, file_name.pathmap("%{^dotfiles/,.}p"))
  end
end

# Define the destination files based on the sources.
DEST_FILES = SOURCES.map{|f| destination f }
# Add destination files to the CLOBBER list for cleanup.
CLOBBER.include(DEST_FILES)

# Define the default task to create symbolic links in the home folder.
task :default => [:links]

desc "make the links in the home folder"
task :links => DEST_FILES

# Define single tasks for each source file to create symbolic links.
SOURCES.each do |source_file|
  destination_file = destination source_file
  file destination_file => source_file do
    # Create the destination folder if it doesn't exist.
    mkdir_p destination_file.pathmap("%d")
    # Create a symbolic link in the home folder.
    sh "ln -sb #{Pathname(source_file).realpath} #{destination_file}"
  end
end

# Define a backup archive task for dotfiles that could be overwritten.
BACKUP_ARCHIVE = File.join(OUTPUT_FOLDER, "dotfiles.vim.backup.tar")
file BACKUP_ARCHIVE do |f|
  # Create a tar archive of existing dotfiles for backup.
  sh "tar cf #{f.name} #{DEST_FILES.join(" ")}; true"
end

desc "backup any existing file that would be overwritten"
task :backup => BACKUP_ARCHIVE
