require 'fileutils'
require 'pathname'
require 'shellwords'

class DmgInstallerPlugin < Plugin
  requires_version '1.1.4'
end

class DmgInstaller
  include Plugins::Dialogs
  include FileUtils

  attr_accessor :mount_point, :log

  def run_using(item)
    path = "#{Dir.home}/Downloads/#{item}.dmg"
    install(path)
  end

  def install_selected
    install get_finder_path
  end

  def install(path)
    @log = []
    return MessageBoard.display.error_message("Selected file is not a dmg. #{path}") unless path.end_with? ".dmg"

    @log << "Looks like a dmg to me. Proceeding with install."
    mount path
    copy_apps
    cleanup path

    MessageBoard.display.success_message(@log.join("\n"))
  end

  def get_finder_path
    result = `osascript -e 'tell app "Finder"' -e 'set selectedItem to (posix path of (the selection as alias))' -e 'end tell'`
    if result.nil?
      "no_file_selected"
    else
      result.strip!
    end
  end

  def mount path
    @mount_point = Pathname.new "/Volumes/#{rand(36**8).to_s(36)}"
    escaped_path = Shellwords.escape(path)
    result = `hdiutil attach -mountpoint #{@mount_point} #{escaped_path}`
  end

  def copy_apps
    files = @mount_point.entries.collect { |file| @mount_point+file }
    files.reject! { |file| file.to_s.end_with?(".app") == false }

    files.each { |app| 
      @log << "... found #{app}."
      FileUtils.cp_r app, "/Applications/"
      @log << "... copied #{app}."
    }
  end

  def cleanup path
    result = `hdiutil detach #{@mount_point}`
    `osascript -e 'tell application "Finder" to delete POSIX file "#{path}"'`
    @log << "... finished installing #{path}. Dmg has been deleted."
  end
end

command "Install selected dmg" do
  DmgInstaller.new.install_selected
end

command "Install downloaded dmg" do
  files = Find.find("#{Dir.home}/Downloads", :extension => '.dmg', :type => 'f')
  trigger_item_with(files, DmgInstaller.new)
end
