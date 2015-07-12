class HelpController < ApplicationController
  def broadcasting
    authorize! :read, "broadcasting_help"
  end
end
