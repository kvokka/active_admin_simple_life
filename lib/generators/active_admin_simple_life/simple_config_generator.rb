# frozen_string_literal: true
require "rails/generators"
module ActiveAdminSimpleLife
  class SimpleConfigGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc "Generates simple configuration table for active_admin"

    def generate_migration
      run "rails g model config title:string internal_name:string:index configurable:references{polymorphic} primitive:string:true"
    end

    def copy_model_file
      remove_file "app/models/config.rb"
      copy_file "config_model.rb", "app/models/config.rb"
    end

    def copy_admin_file
      copy_file "config_admin.rb", "app/admin/config.rb"
    end

    def add_lib_dir
      copy_file "require_lib.rb", "config/initializers/require_lib.rb"
    end

    def extend_array_method
      copy_file "array.rb", "lib/array.rb"
    end
  end
end
