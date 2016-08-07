require 'net/http'
require 'socket'

class HttpProxyChecker
  class HttpProxyCheckerError < StandardError; end
  def raise_error(message) raise HttpProxyCheckerError.new(message) end

  def initialize(test_uri, proxy_host, proxy_ports = [80, 8080, 1080, 3128, 60088], timeout = 2)
    @test_uri = test_uri if test_uri.is_a?(URI)
    @test_uri = URI(test_uri) if test_uri.is_a?(String)
    raise_error("test_uri isn't a URI instance") unless @test_uri.is_a?(URI)
    @proxy_host = proxy_host
    @proxy_ports = proxy_ports
    @timeout = timeout
  end

  def check
    result = [false, nil]
    begin
      origin_resp ||= Net::HTTP.get_response(@test_uri)
    rescue
    ensure
      if origin_resp.nil? || origin_resp.code_type != Net::HTTPOK || origin_resp.body.empty?
        raise_error("Can't GET valid test_uri response")
      end
    end
    @proxy_ports.each do |proxy_port|
      begin
        Timeout::timeout(@timeout) do
          proxy_resp ||= Net::HTTP.new(@test_uri.host, @test_uri.port, @proxy_host, proxy_port).start do |http|
            begin
              http.get(@test_uri)
            rescue => e
              next
            end
          end
          unless proxy_resp.nil?
            return [true, proxy_port] if origin_resp.body == proxy_resp.body
            return [true, proxy_port] if proxy_resp.code_type == Net::HTTPProxyAuthenticationRequired
          end
        end
      rescue => e
        next
      end
    end
    [false, nil]
  end
end
