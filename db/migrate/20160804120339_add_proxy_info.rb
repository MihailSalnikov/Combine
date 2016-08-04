class AddProxyInfo < ActiveRecord::Migration
  def change
  	add_column :users, :proxy, :bool
  end
end
