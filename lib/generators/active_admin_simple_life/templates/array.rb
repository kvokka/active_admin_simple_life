# frozen_string_literal: true
class Array
  def fetch_all_objects_from_klasses
    inject([]) do |a, klass|
      a << klass.all.map do |object|
        [I18n.t("activerecord.singular_models.#{klass.to_s.underscore}") + " - #{object}",
         "#{object.class}##{object.id}"]
      end
    end.flatten(1)
  end
end
