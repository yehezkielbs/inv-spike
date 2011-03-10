class SaleDetail < ActiveRecord::Base
  belongs_to :sale
  belongs_to :item
end
