class PagesController < ApplicationController

  def welcome
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def about
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def webdav
    respond_to do |format|
      format.html # index.html.erb
    end
  end

end
