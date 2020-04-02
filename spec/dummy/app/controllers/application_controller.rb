
class ApplicationController < ActionController::Base
  include UniversalTrackManagerConcern


  def show
    render inline: "Hello ", layout: false
  end
end
