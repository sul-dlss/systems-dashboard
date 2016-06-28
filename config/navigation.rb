# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.item :main, 'Status', root_path
    primary.item :systems, 'Systems Information', systems_path
    primary.item :software, 'Software', software_index_path
    primary.item :sources, 'Data Sources', sources_path
  end
end
