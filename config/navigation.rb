# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  # Define the primary navigation
  navigation.items do |primary|
    primary.item :main, 'Main', root_path
    primary.item :puppet, 'Puppet', puppet_index_path
  end
end
