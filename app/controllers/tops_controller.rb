class TopsController < ApplicationController
  def index
    redirect_to '/home' if user_signed_in?
  end
end
