require 'rake'
require 'rake/clean'
require 'pathname'

SOURCE_FILES = `git ls-files bin dotfiles`.split("\n")
OUTPUT_FOLDER = ENV["HOME"]

def destination file_name
  if Pathname(file_name).each_filename.first == "bin"
    File.join(OUTPUT_FOLDER, file_name)
  elsif Pathname(file_name).each_filename.first == "dotfiles"
    File.join(OUTPUT_FOLDER, file_name.pathmap("%{^dotfiles/,.}p"))
  end
end

DEST_FILES = SOURCE_FILES.map{|f| destination f }
CLOBBER.include(DEST_FILES)

task :default => [:links, "submodule:init", "submodule:upstream"]

desc "make the links in the home folder"
task :links => DEST_FILES

SOURCE_FILES.each do |source_file|
  destination_file = destination source_file
  file destination_file => source_file do
    mkdir_p destination_file.pathmap("%d")
    sh "ln -sb #{Pathname(source_file).realpath} #{destination_file}"
  end
end

namespace :submodule do
  SUBMODULES_WITH_UPSTREAM = [
    {
      path: "bundle/vim-latex",
      upstream: "https://github.com/jcf/vim-latex.git",
      ssh: "git@github.com:Enucatl/vim-latex.git",
    },
  ]

  desc "set upstream repositories for submodules"
  task :upstream do
    SUBMODULES_WITH_UPSTREAM.each do |submodule|
      Dir.chdir(submodule[:path]) do
        if `git remote show | grep upstream`.empty?
          sh "git remote add upstream #{submodule[:upstream]}"
        end
        sh "git remote set-url --push origin #{submodule[:ssh]}"
      end
    end
  end

  desc "initialize submodules"
  task :init do
    sh "git submodule init"
    sh "git submodule sync"
    sh "git submodule update"
  end
end

BACKUP_ARCHIVE = File.join(OUTPUT_FOLDER, "dotfiles.vim.backup.tar")
file BACKUP_ARCHIVE do |f|
  sh "tar cf #{f.name} #{DEST_FILES.join(" ")}; true"
end

desc "backup any existing file that would be overwritten"
task :backup => BACKUP_ARCHIVE
