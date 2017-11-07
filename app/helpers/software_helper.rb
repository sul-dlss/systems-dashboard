module SoftwareHelper
  # Shorten a github URL to something to take less space, also converting to
  # a link.
  def github_url(url)
    return '' if url.nil? || url == ''

    shorturl = url.clone
    shorturl.sub!(/^https?:\/\/github.com\//, '')
    shorturl.sub!(/\.git$/, '')

    "<a href='#{url}' target='_blank'>#{shorturl}</a>"
  end

  def release(description)
    return '' if description.nil? || description == ''
    description.sub!(/ \(\S+\)$/, '')
    description.sub!(/Red Hat Enterprise Linux Server/, 'RHEL')
    description.sub!(/ release /, ' ')

    description
  end

  # Given a text string with comma-separated values, convert each comma into a
  # linebreak.
  def separate_commas(comma_list)
    return '' if comma_list.nil? || comma_list == ''
    comma_list.split(',').join('<br />')
  end
end
