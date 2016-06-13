# frozen_string_literal: true
require "active_admin_simple_life/engine"
require "active_admin_simple_life/extensions"
require "active_admin_simple_life/simple_menu"
require "active_admin_simple_life/simple_elements"
module ActiveAdminSimpleLife
  extend SimpleMenu
  ActiveAdmin::ResourceDSL.send :include, ActiveAdminSimpleLife::SimpleElements
end
