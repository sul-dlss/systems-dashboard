class Cache
  class Upgrades
    SCHEDULE_FILE = '/etc/server-reports/schedule'.freeze
    PACKAGES_FILE = '/var/tmp/package-upgrades/packages-by-server.yaml'.freeze

    # Load the schedule of when to upgrade servers, turning into a hash with
    # hash key the server name and value the scheduled week (0..4).
    def load_schedule
      schedule = {}
      File.open(SCHEDULE_FILE, 'r') do |f|
        f.each_line do |line|
          m = /^(\d+)\s+(\S+)/.match(line)
          next if m.nil?
          week = m[1]
          server = m[2]
          schedule[server] = week.to_i
        end
      end

      schedule
    end

    # Create a mapping of weeks to dates, where each week in a year is counted
    # off 1..4, starting again after 4.
    def week_to_date_map
      week_of_year = Time.new.strftime("%V").to_i
      week_count = week_of_year.modulo(4) + 1

      mapping = {}
      for i in 0..3 do
        date = Date.today.beginning_of_week(:monday)
        date += 1 + ((3-date.wday) % 7)
        date += i.week
        mapping[week_count] = date
        week_count += 1
        week_count = 1 if week_count > 4
      end

      mapping[0] = 'On Hold'
      mapping[99] = 'Not Yet Set'
      mapping
    end

    def cache
      require 'activerecord-import'
      require 'activerecord-import/base'
      ActiveRecord::Import.require_adapter('pg')

      week_to_date = week_to_date_map
      schedule = load_schedule

      import_details = []
      schedule.keys.each do |hostname|
        serverrec = Server.find_or_create_by(hostname: hostname)
        server_id = serverrec.id

        date = week_to_date[schedule[hostname]]
        import_details << [server_id, 'upgrades', 'date', date]
      end

      server_packages = YAML.load_file(PACKAGES_FILE)
      server_packages.keys.each do |hostname|
        serverrec = Server.find_or_create_by(hostname: hostname)
        server_id = serverrec.id

        packages = server_packages[hostname]
        import_details << [server_id, 'upgrades', 'packages', packages.to_yaml]
      end

      delete_types = %w(upgrades)
      Detail.delete_all(category: delete_types)
      columns = %w(server_id category name value)
      Detail.import(columns, import_details)
    end
  end
end
