module ApplicationHelper
  require 'yaml'

  # Given a piece of data that could be 0, 1, a list, or nil, translate it to an
  # asterisk if 1 or an array and empty string otherwise.
  def asterisk(data)
    return '' if data.nil?
    return '*' if data.is_a?(Array) && !data.empty?
    return '*' if data.is_a?(Hash) && !data.empty?
    return '*' if data.is_a?(Fixnum) && data == 1
    return '*' if data.is_a?(String) && data == "1"

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
    return '' if timestamp == '' || timestamp.nil?
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

  # Return a CSS value saying if a field should be marked specially for having
  # been flagged.
  def status_flag(flags, host, fields)
    return 'flagged' if flags.key?(host) && flags[host].key?(fields)
    'normal'
  end

  # Given an ossec severity rating (0..10), convert it into a text display for
  # users that includes the numeric plus text.
  def cvss_score_to_text(score)
    return '' unless score.is_a?(Fixnum) || score.is_a?(Float)
    if score == 0
      return ''
    elsif score < 4.0
      return score.to_s + ' - Low'
    elsif score < 7.0
      return score.to_s + ' - Medium'
    elsif score < 9.0
      return score.to_s + ' - High'
    else
      return score.to_s + ' - Critical'
    end
  end

  # Given a textual severity rating, turn it into an OSSEC score.
  def cvss_text_to_score(level)
    return level if level.is_a?(Fixnum) || level.is_a?(Float)

    severity_ordering = { 'Critical'  => 9.0,
                          'Important' => 7.0,
                          'High'      => 7.0,
                          'Moderate'  => 4.0,
                          'Low'       => 1.0,
                          'Unknown'   => 1.0,
                          ''          => 0 }
    return 1.0 unless severity_ordering.key?(level)
    severity_ordering[level]
  end
end
