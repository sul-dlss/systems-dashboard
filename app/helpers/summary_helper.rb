module SummaryHelper

  # Decide if a host is expired.  We do this by checking to see if the server
  # has less than some required amount of data.  Formerly upgrades would
  # cache for several weeks, which meant that a server only with upgrade data
  # would still be considered expired.  We keep this check in case we come up
  # with other cases in the future.
  def expired_host(server)
    server.keys.each do |detail|
      next if detail == 'upgrades'
      next unless server[detail].is_a?(Hash)
      return false if server[detail].keys.count > 0
    end

    true
  end
end
