# frozen_string_literal: true
module ActiveAdminSimpleLife
  module SimpleMenu
    # for proper work, model must have class method `mail_fields`, which return array of field symbols.
    # references write as is, like `foo_id`
    #
    # in options can take:
    # menu_priority:integer
    # menu_parent:string
    # permitted_params:array for some additions to main_fields permitted params

    def simple_menu_for(klass, options = {})
      ActiveAdmin.register klass do
        menu_options = options.slice(:priority, :parent)
        menu menu_options if menu_options.any?
        permitted_params = options[:permitted_params]
        permit_params(*(klass.main_fields + (permitted_params || [])))
        actions :all, except: [:show]

        controller.class_variable_set(:@@permitted_params, permitted_params)
        controller.class_variable_set(:@@klass, klass)

        controller do
          def scoped_collection
            permitted_params = self.class.class_variable_get :@@permitted_params
            self.class.class_variable_get(:@@klass).includes(*permitted_params.map(&:cut_id))
          end
        end if permitted_params

        index_for_main_fields klass
        filter_for_main_fields klass
        form_for_main_fields klass
      end
    end
  end
end