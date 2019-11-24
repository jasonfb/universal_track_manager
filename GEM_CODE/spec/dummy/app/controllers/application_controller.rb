
class ApplicationController < ActionController::Base
  def show
    render inline: "Hello ", layout: false
  end
end