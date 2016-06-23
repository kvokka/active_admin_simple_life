# frozen_string_literal: true
module ActiveAdminSimpleLife
  module SimpleElements
    ActiveAdmin.send :include, ActiveAdminSimpleLife::Extensions
    include Extensions
    def index_for_main_fields(klass, options = {})
      max_length = options[:max_length]
      add_fields = [options[:add]].flatten.compact
      position = options[:position]
      index download_links: false do
        selectable_column
        id_column
        klass.main_fields.insert(position, *add_fields).each do |symbol|
          column(I18n.t("activerecord.attributes.#{klass.to_s.underscore}.#{symbol}"), sortable: symbol) do |current|
            plural_symbol = symbol.to_s.pluralize  
            field_value = current.send(ExtensionedSymbol.new(symbol).cut_id)
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
              if klass.respond_to?(plural_symbol)
                field_value && I18n.t("activerecord.attributes.#{klass.underscore}.#{plural_symbol}.#{field_value}") 
              else
                truncate_field field_value.to_s, max_length
              end
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
          filter ExtensionedSymbol.new(f).cut_id, collection: genders
        else
          filter ExtensionedSymbol.new(f).cut_id
        end
      end
    end

    def form_for_main_fields(klass, &block)
      form do |f|
        f.semantic_errors(*f.object.errors.keys)
        f.inputs do
          klass.main_fields.each do |ff|
            ff_cut_id = ExtensionedSymbol.new(ff).cut_id
            if ff == ff_cut_id
              f.input ff_cut_id
            else
              f.input ff_cut_id, as: :select, member_label: :to_s
            end
          end
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
          nested_klass.main_fields.map { |f| ExtensionedSymbol.new(f).cut_id }.each do |nested_field|
            form.input(nested_field) unless nested_field == main_model_name
          end
        end
      end
    end
  end
end
