# frozen_string_literal: true
ActiveAdmin.register Config do
  menu priority: 10
  permit_params(*(Config.main_fields + [:configurable_identifier]))
  actions :all, except: [:show]

  index do
    selectable_column
    id_column
    [:title, :internal_name].each { |field| column field }
    column :configurable do |c|
      if c.configurable
        link_to I18n.t("activerecord.models.#{c.configurable_type.underscore}") + " - #{c.configurable}",
                [:admin, c.configurable]
      else
        c.primitive
      end
    end
    actions
  end

  [:title, :internal_name].each { |f| filter f }

  # Inject needed classes here, which will be listed in select
  # object_list = [Foo, Bar, Baz]
  object_list = []

  form do |f|
    f.semantic_errors(*f.object.errors.keys)
    f.inputs do
      f.input :title
      f.input :internal_name
      f.input  :configurable_identifier,
               collection: object_list.fetch_all_objects_from_klasses,
               value:      "#{resource.class}##{resource.id}"
      f.input :primitive
    end
    f.actions
  end
end
