# frozen_string_literal: true
module ActiveAdminSimpleLife
  module SimpleMenu
    include Extensions
    # for proper work, model must have class method `mail_fields`, which return array of field symbols.
    # references write as is, like `foo_id`
    #
    # in options can take:
    # menu_priority:integer
    # menu_parent:string
    # permitted_params:array for some additions to main_fields permitted params

    # def simple_menu_for(klass, options = {})
    def for(klass, options = {}, &blk)
      ActiveAdmin.register klass do
        options = {index: {}, form: {}, filter: {}}.merge options
        permitted_params = options.delete :permitted_params
        permit_params(*(klass.main_fields + (permitted_params || [])))
        # menu_options = options.slice(:priority, :parent, :if)
        menu options if options.any?

        actions :all, except: [:show]

        controller.class_variable_set(:@@permitted_params, permitted_params)
        controller.class_variable_set(:@@klass, klass)

        controller do
          def scoped_collection
            permitted_params = self.class.class_variable_get :@@permitted_params
            self.class.class_variable_get(:@@klass).includes(*permitted_params.map{|symbol| ExtensionedSymbol.new(symbol).cut_id})
          end
        end if permitted_params

        %i[index filter form].each do |action| 
            send "#{action}_for_main_fields", klass, options[action] unless options[action][:skip] == true
        end
        instance_exec &blk if block_given?
      end
    end
  end
end
