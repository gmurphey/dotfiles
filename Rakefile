require 'rake'
require 'erb'

task :all => ["setup:all"]

namespace :setup do
  desc "sets up zsh, updates dotfiles and links fonts"
  task :all => ["install:all", :dotfiles]

  desc "links dotfiles into home directory"
  task :dotfiles do
    replace_all = false
    files = Dir['*'] - %w[Rakefile README.md oh-my-zsh]
    files.each do |file|
      system %Q{mkdir -p "$HOME/.#{File.dirname{file}}"} if file =~ /\//

      target_file = File.join(ENV["HOME"], ".#{file.sub(/\.erb$/, '')}")

      if File.exist?(target_file)
        if File.identical? file, target_file
          puts "using #{file}"
        elsif replace_all
          replace_file(file)
        else
          print "overwrite #{target_file}? [ynaq] "
          case $stdin.gets.chomp
          when "a"
            replace_all = true
            replace_file(file)
          when "y"
            replace_file(file)
          when "q"
            exit
          else
            puts "skipping #{target_file}"
          end
        end
      else
        link_file(file)
      end
    end
  end
end

namespace :install do
  desc "installs brew, casks, and oh-my-zsh"
  task :all => [:brew, :zsh]

  desc "installs brew on the system"
  task :brew do
    unless File.exists?("/usr/local/bin/brew")
      puts "installing brew"
      sh %Q{/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"}
    else
      puts "already using brew"
    end
  end

  desc "installs oh-my-zsh and switch to zsh"
  task :zsh do
    install_oh_my_zsh
    switch_to_zsh
  end
end

def replace_file(file)
  if file =~ /.ttf$/
    system %Q{rm -rf "$HOME/Library/Fonts/#{File.basename(file)}"}
  else
    system %Q{rm -rf "$HOME/.#{file.sub(/\.erb$/, '')}"}
  end

  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts "creating ~/.#{file.sub(/\.erb$/, '')}"
    File.open(File.join(ENV["HOME"], ".#{file.sub(/\.erb$/, '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  elsif file =~ /.ttf$/
    puts "copying #{file}"
    system %Q{cp "#{file}" "$HOME/Library/Fonts/#{File.basename(file)}"}
  else
    puts "linking #{file}..."
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end

def run_from_file(path_array, &block)
  package_file = File.join(File.dirname(__FILE__), path_array)

  if File.exist? package_file
    File.readlines(package_file).map(&:chomp).each do |package|
      unless package[0] == "#"
        block.call(package)
      end
    end
  else
    puts "could not find #{package_file}"
  end
end

def switch_to_zsh
  if ENV["SHELL"] =~ /zsh/
    puts "using zsh"
  else
    print "switch to zsh? (recommended) [ynq] "
    case $stdin.gets.chomp
    when 'y'
      puts "switching to zsh"
      system %Q{chsh -s `which zsh`}
    when 'q'
      exit
    else
      puts "skipping zsh"
    end
  end
end

def install_oh_my_zsh
  if File.exist?(File.join(ENV['HOME'], ".oh-my-zsh"))
    puts "found ~/.oh-my-zsh"
  else
    print "install oh-my-zsh? [ynq] "
    case $stdin.gets.chomp
    when 'y'
      puts "installing oh-my-zsh"
      system %Q{git clone https://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh"}
    when 'q'
      exit
    else
      puts "skipping oh-my-zsh, you will need to change ~/.zshrc"
    end
  end
end
