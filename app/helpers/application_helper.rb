module ApplicationHelper
  # Given a piece of data that could be 0, 1, a list, or nil, translate it to an
  # asterisk if 1 or an array and empty string otherwise.
  def asterisk(data)
    return '' if data.nil?
    return '*' if data.is_a?(Array)
    return '*' if data.is_a?(Hash)
    return '*' if data.is_a?(Fixnum) && data == 1

    ''
  end

  # For hash entries that may or may not exist, such as vmware settings, we
  # use this to expand a possibly missing parent into an empty string.
  def check_child(parent, child)
    return '' if parent.nil?
    return '' if parent[child].nil?
    parent[child]
  end

  # Change the power status boolean into an on or off string.  At some point
  # the yaml parser helpfully changes it from On/Off into this instead.
  def status(status_boolean)
    return '' if status_boolean == ''
    return 'On' if status_boolean
    'Off'
  end

  # Format the ossec files listing hash into text suited for display.
  def ossec_files(changed_files)
    return 'No changed files found' unless changed_files.is_a?(Hash)
    text = []
    changed_files.keys.sort.each do |fname|
      text << fname + ': ' + changed_files[fname]
    end

    return text.join("\n") if text.count > 0
    'No changed files found'
  end

  # Given a full date and time string, return only the date itself, for things
  # that we don't need full precision on for normal display.
  def date_only(timestamp)
    return '' if timestamp == ''
    begin
      date = Date.parse(timestamp).strftime('%Y-%m-%d')
    rescue ArgumentError
      date = ''
    end
    date
  end

  # Given a string of one or more URLs, separate them out and then make them
  # actual links.
  def parse_links(urls)
    links = []
    return '' if urls.nil?
    urls.split(' ').each do |url|
      links << "<a href='#{url}' target='_blank'>#{url}</a>"
    end
    links.join('<br />')
  end

  # Shorten a hostname by removing the stanford.edu domain for display.
  def shorthost(hostname)
    hostname.sub(/\.stanford\.edu$/, '')
  end

  def status_flag(flags, host, field)
    return 'flagged' if flags.key?(host) && flags[host].key?(field)
    'normal'
  end

end
