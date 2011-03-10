class Inventory < Netzke::Basepack::SimpleApp

  @@simple_components = %w(customers items)
  @@composite_components = %w(sales)

  def configuration
    simple_components_config = @@simple_components.map do |name|
      {
          :text => name.humanize,
          :component => name,
          :icon => uri_to_icon(:table),
          :leaf => true
      }
    end

    sup = super
    sup.merge(
        :items => [
            {
                :region => :north,
                :border => false,
                :height => 35,
                #         :html => %Q{
                #           <div style="margin:10px; color:#333; text-align:center; font-family: Helvetica;">
                #             <a style="color:#B32D15; text-decoration: none" href="http://netzke.org">BLAH&ndash;BLAH</a> Demo
                #           </div>
                #         },
                :id => 'main_header'
            },
            {
                :region => :center,
                :layout => :border,
                :border => false,
                :items => [
                    status_bar_config,
                    {
                        :region => :center,
                        :layout => :border,
                        :items => [
                            #menu_bar_config,
                        main_panel_config(:ref => "../../mainPanel"),
                        {
                            # Navigation
                            :region => :west,
                            :width => 250,
                            :split => true,
                            :xtype => :treepanel,
                            :auto_scroll => true,
                            :title => 'Main Menu',
                            :root_visible => false,
                            :ref => '../../navigation',
                            :root => {
                                :text => 'Main Menu',
                                :expanded => true,
                                :children => [
                                    {
                                        :text => 'Master Data',
                                        :expanded => true,
                                        :children => simple_components_config
                                    },
                                    {
                                        :text => 'Transactions',
                                        :expanded => true,
                                        :children => [
                                            :text => 'Sales',
                                            :icon => uri_to_icon(:user_user_suit),
                                            :leaf => true,
                                            :component => 'sales'
                                        ]
                                    }
                                ]
                            }
                        }
                        ]
                    }
                ]
            }
        ]
    )
  end

  # Components
  @@simple_components.each do |name|
    component name.to_sym,
              :model => name.classify,
              :title => name.humanize,
              :class_name => 'Basepack::GridPanel',
              :lazy_loading => true,
              :persistence => true
  end

  @@composite_components.each do |name|
    component name.to_sym,
      :lazy_loading => true,
      :title => name.humanize
  end

#   component :bosses,
#     :class_name => "Basepack::GridPanel",
#     :model => "Boss",
#     :lazy_loading => true,
#     :title => "Bosses",
#     :persistence => true
#
#   component :clerks,
#     :class_name => "Basepack::GridPanel",
#     :model => "Clerk",
#     :lazy_loading => true,
#     :title => "Clerks",
#     :persistence => true
#
#   component :customized_clerks,
#     :class_name => "ClerkGrid",
#     :lazy_loading => true,
#     :title => "Customized Clerks"
#
#   component :custom_action_grid,
#     :model => "Boss",
#     :lazy_loading => true,
#     :title => "Custom Action Grid",
#     :persistence => true
#
#   component :bosses_and_clerks,
#     :lazy_loading => true,
#     :title => "Bosses and Clerks"
#
#   component :clerk_paging_form,
#     :lazy_loading => true,
#     :title => "Clerk Paging Form",
#     :model => "Clerk",
#     :class_name => "Netzke::Basepack::PagingFormPanel"
#
#   component :clerk_paging_lockable_form,
#     :lazy_loading => true,
#     :title => "Clerk Paging Lockable Form",
#     :model => "Clerk",
#     :class_name => "Netzke::Basepack::PagingFormPanel",
#     :mode => :lockable
#
# # #   component :clerk_form_custom_layout,
# # #     :class_name => "ClerkForm"
#
#   # A simple panel thit will render a page with links to different Rails views that have embedded widgets in them
#   component :embedded,
#     :class_name => "Basepack::Panel",
#     :auto_load => "demo/embedded",
#     :padding => 15,
#     :title => "Components embedded into Rails views",
#     :auto_scroll => true
#
#   action :about, :icon => :information
#
#   # Overrides SimpleApp#menu
#   def menu
#     ["->", :about.action]
#   end
#
#   js_method :on_about, <<-JS
#     function(e){
#       var msg = [
#         '',
#         'Source code for this demo: <a href="https://github.com/skozlov/netzke-demo">GitHub</a>.',
#         '', '',
#         '<div style="text-align:right;">Why follow <a href="http://twitter.com/nomadcoder">NomadCoder</a>?</div>'
#       ].join("<br/>");
#
#       Ext.Msg.show({
#         width: 300,
#          title:'About',
#          msg: msg,
#          buttons: Ext.Msg.OK,
#          animEl: e.getId()
#       });
#     }
#   JS
#
  # Overrides Ext.Component#initComponent to set the click event on the nodes
  js_method :init_component, <<-JS
    function(){
      Netzke.classes.Inventory.superclass.initComponent.call(this);
      this.navigation.on('click', function(e){
        if (e.attributes.component) {
          this.appLoadComponent(e.attributes.component);
        }
      }, this);
    }
  JS
#
#   # Overrides SimpleApp#process_history, to initially select the node in the navigation tree
#   js_method :process_history, <<-JS
#     function(token){
#       if (token) {
#         var node = this.navigation.root.findChild("component", token, true);
#         if (node) node.select();
#       }
#       #{js_full_class_name}.superclass.processHistory.call(this, token);
#     }
#   JS
end
