#encoding: utf-8 
class Cpanel::PhantomsController < Cpanel::ApplicationController
  set :views, ENV["VIEW_PATH"] + "/cpanel/phantoms"
  set :layout, :"../layouts/layout"
  helpers PhantomHelper

  # root page
  get "/" do
    @phantoms = Phantom.all

    haml :index, layout: settings.layout
  end
end
