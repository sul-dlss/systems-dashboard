module PuppetHelper
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

  # Format a Gemnasium URL for a project, with the text including the number of
  # advisories the project has.  If there is no Gemnasium URL, or no project,
  # just return a '-'.
  def gemnasium_url(project, gemdata)
    return '-' if project.nil?

    m = /^https?:\/\/github.com\/(.+)\.git$/.match(project)
    return '-' if m.nil?

    slug = m[1]
    return '-' unless gemdata.key?(slug)

    advisories = gemdata[slug].count
    if advisories == 0
      url = "https://gemnasium.com/github.com/#{slug}"
    else
      url = "https://gemnasium.com/github.com/#{slug}/alerts"
    end

    "<a href='#{url}' target='_blank'>#{advisories}</a>"
  end
end
