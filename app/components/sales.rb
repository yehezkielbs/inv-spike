class Sales < CompositeComponentBase
  def self.master_name
    'sales'
  end

  def self.detail_name
    'sale_details'
  end

  initialize_class
end
