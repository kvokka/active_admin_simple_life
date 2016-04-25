# frozen_string_literal: true
module ActiveAdminSimpleLife
  module SimpleElements
    def index_for_main_fields(klass, options = {})
      max_length = options[:max_length]
      index download_links: false do
        selectable_column
        id_column
        klass.main_fields.each do |symbol|
          column(I18n.t("activerecord.attributes.#{klass.to_s.underscore}.#{symbol}"), sortable: symbol) do |current|
            field_value = current.send(symbol.cut_id)
            case field_value
            when ActiveRecord::Base
              link_to truncate_field(field_value, max_length),
                      send(fetch_path(field_value), field_value.id)
            when ::ActiveSupport::TimeWithZone, Time, Date
              I18n.l field_value, format: :long
            when TrueClass
              span_true
            when FalseClass
              span_false
            else
              truncate_field field_value.to_s, max_length
            end
          end
        end
        actions
      end
    end

    # it check only for gender field for now
    def filter_for_main_fields(klass)
      klass.main_fields.each do |f|
        if f == :gender
          filter f.cut_id, collection: genders
        else
          filter f.cut_id
        end
      end
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

      def truncate_field(field, max_length = 50)
        length = max_length || 50
        truncate(field.to_s, length: length)
      end

      def fetch_path(field)
        "edit_admin_#{field.class.to_s.underscore}_path"
      end

      def span_true
        Arbre::Context.new { span(class: "status_tag yes") { I18n.t("boolean.active") } }
      end

      def span_false
        Arbre::Context.new { span(class: "status_tag no") { I18n.t "boolean.not_active" } }
      end

      def genders
        [[I18n.t("active_admin.genders.male"), true],
         [I18n.t("active_admin.genders.female"), false]]
      end
  end
end
