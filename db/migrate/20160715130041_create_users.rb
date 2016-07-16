class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
      t.string :time
      t.integer :vk_id
      t.string :ip
    end
  end
end
