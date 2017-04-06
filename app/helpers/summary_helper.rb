module SummaryHelper

  # Decide if a host is expired.  We do this by checking to see if the server
  # has less than some required amount of data.  This is done because the
  # 'upgrades' detail will cache data for several weeks, leading to servers
  # that have otherwise been retired to appear.  So if a host has only upgrades
  # data, consider it expired.
  def expired_host(server)
    server.keys.each do |detail|
      next if detail == 'upgrades'
      next unless server[detail].is_a?(Hash)
      return false if server[detail].keys.count > 0
    end

    true
  end
end
