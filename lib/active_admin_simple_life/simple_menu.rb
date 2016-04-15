# frozen_string_literal: true
module ActiveAdminSimpleLife
  module ActiveAdminSimpleMenu
    # for proper work, model must have class method `mail_fields`, which return array of field symbols.
    # references write as is, like `foo_id`
    #
    # in options can take:
    # menu_priority:integer
    # menu_parent:string
    # permitted_params:array for some additions to main_fields permitted params
    MAX_COLUMN_LENGTH ||= 50

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

    def index_for_main_fields(klass)
      index download_links: false do
        selectable_column
        id_column
        klass.main_fields.each do |symbol|
          column(I18n.t("activerecord.attributes.#{klass.to_s.underscore}.#{symbol}"), sortable: symbol) do |current|
            field_value = current.send(symbol.cut_id)
            case field_value
            when String
              truncate_field field_value
            when ::ActiveSupport::TimeWithZone, Time, Date
              I18n.l field_value, format: :long
            when TrueClass
              span_true
            when FalseClass
              span_false
            else
              link_to truncate_field(field_value), send(fetch_path(field_value), field_value.id)
            end
          end
        end
        actions
      end
    end

    def filter_for_main_fields(klass)
      klass.main_fields.each { |f| filter f.cut_id }
    end

    def form_for_main_fields(klass, &block)
      form do |f|
        f.semantic_errors(*f.object.errors.keys)
        f.inputs do
          klass.main_fields.each { |ff| f.input ff.cut_id }
          f.instance_eval(&block) if block_given?
        end
        f.actions
      end
    end

    # simple nested set for 2 classes with defined main_fields
    def nested_form_for_main_fields(klass, nested_klass)
      form_for_main_fields(klass) do |form_field|
        nested_table_name = nested_klass.to_s.underscore.pluralize.to_sym
        main_model_name = klass.to_s.underscore.to_sym
        form_field.has_many nested_table_name, allow_destroy: true do |form|
          nested_klass.main_fields.map(&:cut_id).each do |nested_field|
            form.input(nested_field) unless nested_field == main_model_name
          end
        end
      end
    end

    def cut_id
      to_s.sub(/_id$/, "").to_sym
    end

    private

      def truncate_field(field)
        truncate(field.to_s, length: MAX_COLUMN_LENGTH)
      end

      def fetch_path(field)
        "admin_#{field.class.to_s.underscore}_path"
      end

      def span_true
        Arbre::Context.new { span(class: "status_tag yes") { I18n.t("boolean.active") } }
      end

      def span_false
        Arbre::Context.new { span(class: "status_tag no") { I18n.t "boolean.disactive" } }
      end
  end
end
