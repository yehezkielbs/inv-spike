class CompositeComponentBase < Netzke::Basepack::BorderLayoutPanel
  def self.master_name
    raise NotImplementedError
  end

  def self.detail_name
    raise NotImplementedError
  end

  def master_name
    self.class.master_name
  end

  def detail_name
    self.class.detail_name
  end

  def configuration
    super.merge(
        :items => [
            {
                :region => :center,
                :title => master_name.humanize,
                :name => master_name,
                :class_name => 'Basepack::GridPanel',
                :model => master_name.classify
            },
            #        :sale_info.component(
            #          :region => :east,
            #          :name => 'info',
            #          :width => 240,
            #          :split => true
            #        ),
            detail_name.to_sym.component(
                :region => :south,
                :title => detail_name.humanize,
                :height => 250,
                :split => true
            )
        ]
    )
  end

  def self.initialize_class
    js_property :header, false

    # Overriding initComponent
    js_method :init_component, <<-JS
        function(){
          // calling superclass's initComponent
          #{js_full_class_name}.superclass.initComponent.call(this);

          // setting the 'rowclick' event
          this.getChildComponent("#{master_name}").on('rowclick', function(self, rowIndex){
            // The beauty of using Ext.Direct: calling 3 endpoints in a row, which results in a single call to the server!
            this.select#{master_name.classify}({#{master_name.classify.foreign_key}: self.store.getAt(rowIndex).get('id')});
            this.getChildComponent("#{detail_name}").getStore().reload();
            //this.getChildComponent("sale_info").updateStats();
          }, this);
        }
    JS

    endpoint "select_#{master_name.classify.downcase}".to_sym do |params|
      foreign_key = master_name.classify.foreign_key
      # store selected boss id in the session for this component's instance
      component_session["selected_#{foreign_key}".to_sym] = params[foreign_key.to_sym]
    end

    component detail_name.to_sym do
      foreign_key = master_name.classify.foreign_key
      default_attr = {foreign_key.to_sym => component_session["selected_#{foreign_key}".to_sym]}
      {
          :class_name => 'Netzke::Basepack::GridPanel',
          :model => detail_name.classify,
          :load_inline_data => false,
          :scope => default_attr,
          :strong_default_attrs => default_attr
      }
    end

    #  component :sale_info do
    #    {
    #      :class_name => 'SaleInfo',
    #      :sale_id => component_session[:selected_sale_id]
    #    }
    #  end
  end
end
