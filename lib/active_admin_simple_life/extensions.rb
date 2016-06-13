# frozen_string_literal: true
module ActiveAdminSimpleLife
  module Extensions
    require "forwardable"
    class ExtensionedSymbol < DelegateClass(Symbol)
      def cut_id
        to_s.sub(/_id$/, "").to_sym
      end
    end
  end
end
module ActiveAdmin
  module Views
    class IndexAsTable < ActiveAdmin::Component
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

      def truncate_field(field, max_length = 50)
        length = max_length || 50
        truncate(field.to_s, length: length)
      end

      def fetch_path(field)
        "edit_admin_#{field.class.to_s.underscore}_path"
      end
    end
  end
end
