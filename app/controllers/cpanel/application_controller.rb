#encoding: utf-8
module Cpanel; end
class Cpanel::ApplicationController < ApplicationController
  before do
    authenticate!
    redirect "/user" unless current_user and current_user.admin?
  end
end
