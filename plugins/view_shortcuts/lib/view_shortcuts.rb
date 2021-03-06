
require 'erb'
require 'cgi'

module Redcar
  class ViewShortcuts
    def self.menus
      Menu::Builder.build do
        sub_menu "Help" do
          item "Keyboard Shortcuts", :command => ViewShortcuts::ViewCommand, :priority => 30
        end
      end
    end
    
    def self.toolbars
      ToolBar::Builder.build do
        item "Keyboard Shortcuts", :command => ViewShortcuts::ViewCommand, :icon => File.join(Redcar::ICONS_DIRECTORY, "keyboard.png"), :barname => :help
      end
    end
  
    class ViewCommand < Redcar::Command
      def execute
        controller = Controller.new
        tab = win.new_tab(HtmlTab)
        tab.html_view.controller = controller
        tab.focus
      end
    end
    
    class Controller
      include HtmlController
      
      def title
        "Shortcuts"
      end
      
      def clean_name(command)
        name = command.to_s.sub("Command","")
        idx = name.rindex("::")
        unless idx.nil?
          name = name[idx+2,name.length]
        end
        name = name.split(/(?=[A-Z])/).map{|w| w}.join(" ").sub("R E P L","REPL")
      end
      
      def index
        rhtml = ERB.new(File.read(File.join(File.dirname(__FILE__), "..", "views", "index.html.erb")))
        rhtml.result(binding)
      end
    end
  end
end
