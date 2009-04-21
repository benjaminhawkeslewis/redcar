
module Redcar
  class CloseTab < Redcar::TabCommand
    key "Ctrl+W"
    icon :CLOSE

    def initialize(tab=nil)
      @tab = tab
    end

    def responses
      result = [[ Gtk::Stock::DISCARD, Gtk::Dialog::RESPONSE_REJECT],
                [ Gtk::Stock::CANCEL, Gtk::Dialog::RESPONSE_CANCEL]]
      if tab.filename
        result = [[ Gtk::Stock::SAVE, Gtk::Dialog::RESPONSE_OK]] + result
      else
        result = [[ Gtk::Stock::SAVE_AS, Gtk::Dialog::RESPONSE_OK]] + result
      end
      result
    end

    def prompt_and_save(&block)
      dialog = Gtk::Dialog.new("Document has unsaved changes",
                                Redcar.win,
                                Gtk::Dialog::MODAL,
                                *responses
                                )
      dialog.vbox.add(Gtk::Label.new("Unsaved changes."))
      dialog_runner = Redcar.win.modal_dialog_runner(dialog)
      
      dialog.signal_connect('response') do |_, response|
        dialog_runner.close
        case response
        when Gtk::Dialog::RESPONSE_OK
          if tab.filename
            tab.save
          else
            Redcar::Dialog.choose_file(win, "Save As")
          end
          block.call
        when Gtk::Dialog::RESPONSE_REJECT
          block.call
        when Gtk::Dialog::RESPONSE_CANCEL
          # do nothing
        end
      end
      dialog_runner.run
    end

    def close_tab
      @tab ||= tab
      @tab.close if @tab
      @tab = nil # want the Tabs to be garbage collected
    end

    def execute
      if tab.document.modified?
        prompt_and_save { close_tab }
      else
        close_tab
      end
    end
  end
end
