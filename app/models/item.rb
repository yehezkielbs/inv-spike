class Item < ActiveRecord::Base
  validates_presence_of :code, :name
end
