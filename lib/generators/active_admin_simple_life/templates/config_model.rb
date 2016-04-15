# frozen_string_literal: true
class Config < ActiveRecord::Base
  belongs_to :configurable, polymorphic: true
  validates :title, :internal_name, presence: true
  validates :title, :internal_name, uniqueness: true

  attr_accessor :configurable_identifier

  def self.main_fields
    [:title, :internal_name, :configurable, :primitive]
  end

  def configurable_identifier
    "#{configurable_type}##{configurable_id}"
  end

  def configurable_identifier=(data)
    if data.present?
      config_data = data.split('#')
      self.configurable_type = config_data[0]
      self.configurable_id = config_data[1]
    else
      self.configurable_type = nil
      self.configurable_id = nil
    end
  end
end
