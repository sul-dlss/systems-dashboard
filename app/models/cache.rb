# Shared functions for all cache classes.
class Cache

  def initialize
    @aliases = {}
  end

  # Do an initial loading of all host aliases.
  def load_aliases
    aliases = Detail.where(category: 'netdb', name: 'aliases')
    aliases.each do |a|
      next if a.value.nil?
      hosts = YAML.load(a.value)
      next if hosts.empty?

      server = Server.find(a.server_id)
      hosts.each do |aliasname|
        aliasname += '.stanford.edu'
        @aliases[aliasname] = server.hostname
      end
    end
  end

  # Given a hostname, find if it is an alias to another hostname and return
  # that hostname if so.
  def canonical_host(hostname)
    load_aliases if @aliases.empty?

    return @aliases[hostname] if @aliases.key?(hostname)
    hostname
  end
end
