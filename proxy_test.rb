 require 'net/http'
 require 'socket'

def is_port_open?(ip, port)
  begin
    Timeout::timeout(1) do
      begin
        s = TCPSocket.new(ip, port)
        s.close
        return true
      rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
        return false
      end
    end
  rescue Timeout::Error
  end

  return false
end

def proxy?(proxy_addr, proxy_ports = [80, 8080, 1080, 3128, 60088])
	proxy = false
	msg = "proxy "+proxy_addr.to_s+" ports: "
	test = Net::HTTP.get(URI('http://stackoverflow.com')) 
	proxy_ports.each do |proxy_port|
		if is_port_open?(proxy_addr, proxy_port)
			Net::HTTP::Proxy(proxy_addr, proxy_port).start('www.google.ru') do |http|
				begin
					if http.get(URI('http://stackoverflow.com')) != test 
						proxy = true
						msg += proxy_port.to_s+" "
					end	
				end
			end
		else
			# msg += "port "+proxy_port.to_s+" not work"
		end
	end

	if proxy
		return msg, proxy 
	else
		return false
	end
end


