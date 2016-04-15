# frozen_string_literal: true
$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "active_admin_simple_life/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "active_admin_simple_life"
  s.version     = ActiveAdminSimpleLife::VERSION
  s.authors     = ["Kvokka"]
  s.email       = ["root_p@mail.ru"]
  s.homepage    = "https://github.com/kvokka/active_admin_simple_life"
  s.summary     = "Quick simple resources creation in ActiveAdmin"
  s.description = "This gem provide the ability to create ActiveAdmin resources"\
                  "with 1 line and avoid code duplication."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.0"
  s.add_dependency "activeadmin"
end
