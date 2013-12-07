require 'twitter'

class Api::TimelineController < ApplicationController
  def interval
    @interval = params[:interval]
  end

end
