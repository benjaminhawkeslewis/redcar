require File.join(File.dirname(__FILE__), "..", "spec_helper")

describe Redcar::Window do
  before do
    @window = Redcar::Window.new
    @window.controller = RedcarSpec::WindowController.new
  end  
    
  it "notifies the controller that the menu has changed" do
    @window.controller.should_receive(:menu_changed)
    @window.menu = 1
  end
end