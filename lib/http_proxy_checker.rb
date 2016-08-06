require 'net/http'
require 'socket'

class HttpProxyChecker

  class HttpProxyCheckerError < StandardError; end
  def raise_error(message) raise HttpProxyCheckerError.new(message) end

  def initialize(test_uri, proxy_host, proxy_ports = [80, 8080, 1080, 3128, 60088])
    @test_uri = test_uri if test_uri.is_a?(URI)
    @test_uri = URI(test_uri) if test_uri.is_a?(String)
    raise_error("test_uri isn't a URI instance'") unless @test_uri.is_a?(URI)
    @proxy_host = proxy_host
    @proxy_ports = proxy_ports
  end

  def proxy?
    result = [false, nil]
    @proxy_ports.each do |proxy_port|
      if port_open?(@proxy_host, proxy_port)
        begin
          Net::HTTP.new(@test_uri.host, @test_uri.port, @proxy_host, proxy_port).start do |http|
            begin
              http.get(@test_uri)
              return [true, proxy_port]
            rescue => e
              next
            end
          end
        rescue => e
          next
        end
      end
    end
    [false, nil]
  end

  private

  def port_open?(remote_host, remote_port, timeout = 1)
    begin
      Timeout::timeout(timeout) do
        begin
          TCPSocket.new(remote_host, remote_port).close
          return true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, SocketError
          return false
        end
      end
    rescue Timeout::Error
      return false
    end
  end

end
