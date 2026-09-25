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

SKILL_FOLDERS = Dir.glob([
  'dotfiles/agents/skills/*'
]).select { |f| File.directory?(f) }

# Define the source files by globbing bin and dotfiles directories.
SOURCE_FILES = Dir.glob([
  'bin/*',
  'dotfiles/*',
  'dotfiles/config/*',
  'dotfiles/gnupg/*',
  'dotfiles/ssh/*',
  'dotfiles/codex/**/*',
  'dotfiles/agents/**/*'
]).select do |f|
  File.file?(f) && SKILL_FOLDERS.none? { |folder| f.start_with?("#{folder}/") }
end
# Define source folders that need special handling (auto-discovered).
SOURCE_FOLDERS = Dir.glob([
  'dotfiles/config/*'
]).select { |f| File.directory?(f) }
# Combine source files and folders into a single array.
SOURCES = SOURCE_FILES + SOURCE_FOLDERS
# Define the output folder as the user's home directory.
OUTPUT_FOLDER = ENV['HOME']

# Share the global agent instructions and portable skills with Claude Code.
CLAUDE_SKILLS = %w[archify git-commit-message homelab-logs python-code]
CLAUDE_LINKS = {
  File.join(OUTPUT_FOLDER, '.claude', 'CLAUDE.md') => File.join(OUTPUT_FOLDER, '.codex', 'AGENTS.md')
}
CLAUDE_SKILLS.each do |name|
  CLAUDE_LINKS[File.join(OUTPUT_FOLDER, '.claude', 'skills', name)] =
    File.join(OUTPUT_FOLDER, '.agents', 'skills', name)
end

# Define a method to determine the destination of a file based on its type.
# files in the bin folder are linked to ~/bin
# files in the dotfiles folder are linked to ~ and prefixed with a dot .
# example: dotfiles/bashrc -> ~/.bashrc
def destination(file_name)
  parts = Pathname(file_name).each_filename.to_a

  if parts.first == 'bin'
    File.join(OUTPUT_FOLDER, file_name)
  elsif parts.first == 'dotfiles'
    File.join(OUTPUT_FOLDER, file_name.pathmap('%{^dotfiles/,.}p'))
  end
end

# Define the destination files based on the sources.
DEST_FILES = SOURCES.map { |f| destination f }.compact.uniq
SKILL_DESTINATIONS = SKILL_FOLDERS.map { |f| destination f }.compact.uniq
# Add destination files to the CLOBBER list for cleanup.
CLOBBER.include(DEST_FILES + SKILL_DESTINATIONS + CLAUDE_LINKS.keys)

# Define the default task to create symbolic links in the home folder.
task default: :links

desc 'make the links in the home folder'
task links: DEST_FILES do
  SKILL_FOLDERS.each do |source_folder|
    destination_folder = destination source_folder
    source_path = Pathname(source_folder).realpath.to_s
    mkdir_p destination_folder.pathmap('%d')
    next if File.symlink?(destination_folder) && File.readlink(destination_folder) == source_path

    rm_rf destination_folder if File.exist?(destination_folder) || File.symlink?(destination_folder)
    sh 'ln', '-s', source_path, destination_folder
  end

  CLAUDE_LINKS.each do |destination_file, source_file|
    next unless File.exist?(source_file)
    next if File.symlink?(destination_file) && File.readlink(destination_file) == source_file

    mkdir_p File.dirname(destination_file)
    abort "Refusing to replace #{destination_file}" if File.exist?(destination_file) || File.symlink?(destination_file)

    sh 'ln', '-s', source_file, destination_file
  end
end

# Define single tasks for each source file to create symbolic links.
SOURCES.each do |source_file|
  destination_file = destination source_file
  file destination_file => source_file do
    # Create the destination folder if it doesn't exist.
    mkdir_p destination_file.pathmap('%d')
    # Create a symbolic link in the home folder.
    sh 'ln', '-sb', Pathname(source_file).realpath.to_s, destination_file
  end
end

# Define a backup archive task for dotfiles that could be overwritten.
BACKUP_ARCHIVE = File.join(OUTPUT_FOLDER, 'dotfiles.vim.backup.tar')
file BACKUP_ARCHIVE do |f|
  # Create a tar archive of existing dotfiles for backup.
  sh "tar cf #{f.name} #{DEST_FILES.join(' ')}; true"
end

desc 'backup any existing file that would be overwritten'
task backup: BACKUP_ARCHIVE
