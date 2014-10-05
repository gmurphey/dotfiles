require 'rake'
require 'erb'

task :all => ["setup:all"]

namespace :setup do
  desc "sets up zsh, updates dotfiles and links fonts"
  task :all => ["install:all", :dotfiles, :fonts]

  desc "links dotfiles into home directory"
  task :dotfiles do
    replace_all = false
    files = Dir['*'] - %w[Rakefile README.md oh-my-zsh resources packages]
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

  desc "sets up fonts in system library"
  task :fonts do
    fail unless system %Q{mkdir -p "$HOME/Library/Fonts"}

    Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/resources/fonts/*.ttf") do |font|
      next unless replace_file(font)
    end
  end
end

namespace :install do
  desc "installs brew, casks, and oh-my-zsh"
  task :all => [:brew, :zsh, :packages]

  desc "installs brew on the system"
  task :brew do
    unless File.exists?("/usr/local/bin/brew")
      puts "installing brew"
      sh %Q{/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"}
    else
      puts "already using brew"
    end
  end
  
  desc "installs oh-my-zsh and switch to zsh"
  task :zsh do
    install_oh_my_zsh
    switch_to_zsh
  end

  namespace :packages do
    desc "installs system, gem and npm packages"
    task :all => [:system, :casks, :gems, :npms]

    desc "installs brew packages"
    task :system do
      if system("which brew")
        run_from_file(["packages", "brew"]) { |package| system %Q{brew install #{package}} }
      end
    end
    
    desc "installs brew casks"
    task :casks do
      if system("which brew")
        run_from_file(["packages", "casks"]) { |package| system %Q{brew cask install #{package}} }
      end
    end

    desc "installs global gems"
    task :gems do
      if system("which gem")
        run_from_file(["packages", "rubygems"]) { |package| system %Q{gem install #{package}} }
      end
    end

    desc "installs node packages"
    task :npms do
      if system("which npm")
        run_from_file(["packages", "node"]) { |package| system %Q{npm install -g #{package}} }
      end
    end
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
      unless package.[0] == "#"
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
