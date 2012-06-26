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
          replace_file(target_file, file)
        else
          print "overwrite #{target_file}? [ynaq] "
          case $stdin.gets.chomp
          when "a"
            replace_all = true
            replace_file(target_file, file)
          when "y"
            replace_file(target_file, file)
          when "q"
            exit
          else
            puts "skipping #{target_file}"
          end
        end
      else
        link_file(file, target_file)
      end
    end
  end

  desc "sets up fonts in system library"
  task :fonts do
    target_dir = "$HOME/Library/Fonts"
    fail unless system %Q{mkdir -p #{target_dir}}

    Dir.glob("#{File.expand_path(File.dirname(__FILE__))}/resources/fonts/*.ttf") do |font|
      target = "#{target_dir}/#{File.basename(font)}"
      next unless replace_file(target, font)
    end
  end
end

namespace :install do
  desc "installs brew and oh-my-zsh"
  task :all => [:brew, :zsh, :rvm, :packages]

  desc "installs brew on the system"
  task :brew do
    unless File.exists?("/usr/local/bin/brew")
      puts "installing brew"
      sh %Q{/usr/bin/ruby -e "$(/usr/bin/curl -fksSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"}
    else
      puts "already using brew"
    end
  end

  desc "installs oh-my-zsh and switch to zsh"
  task :zsh do
    install_oh_my_zsh
    switch_to_zsh
  end

  desc "installs rvm"
  task :rvm do
    system %Q{curl -L https://get.rvm.io | bash -s stable --ruby}
    system %Q{source $HOME/.rvm/scripts/rvm}
  end

  namespace :packages do
    desc "installs system, gem and npm packages"
    task :all => [:system, :gems, :npms]

    desc "installs brew packages"
    task :system do
      if system("which brew")
        run_from_file(["packages", "brew"]) { |package| system %Q{brew install #{package}} }
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
        run_from_file(["packages", "npm"]) { |package| system %Q{npm install -g #{package}} }
      end
    end
  end
end

def replace_file(old_file, new_file)
  puts "removing #{old_file}..."
  system %Q{rm -rf #{old_file}}
  link_file(old_file, new_file)
end

def link_file(target, file)
  if file =~ /.erb$/
    puts "creating #{target}"
    File.open(target, 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  elsif file =~ /.ttf$/
    puts "copying #{file}"
    system %Q{cp #{file} #{target}}
  else
    puts "linking #{file}..."
    system %Q{ln -s "#{file}" "#{target}"}
  end
end

def run_from_file(path_array, &block)
  package_file = File.join(File.dirname(__FILE__), path_array)

  if File.exist? package_file
    File.readlines(package_file).map(&:chomp).each do |package|
      block.call(package)
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