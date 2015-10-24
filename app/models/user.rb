#encoding: utf-8
require "model-base"
class User
    include DataMapper::Resource
    include Utils::DataMapper::Model
    #extend  Utils::DataMapper::Model
    include Utils::ActionLogger

    property :id        , Serial 
    property :name      , String
    property :email     , String  , :required => true, :unique => true
    property :password  , String  , :required => true
    property :weixin    , String 

    after :create do |obj|
      update(name: email.split(/@/).first) if name.nil? 
    end

    def admin?
      Settings.admins.split(/,/).include?(self.email)
    end

    # instance methods
    def human_name
      "用户"
    end
end
