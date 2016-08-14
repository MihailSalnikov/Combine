class Ips < ActiveRecord::Migration
  def change
  	add_column :users, :local_ip, :string
  	add_column :users, :ipv6, :string
  	add_column :users, :public_ip, :string
  end
end
