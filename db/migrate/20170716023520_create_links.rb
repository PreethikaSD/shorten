class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
    	t.belongs_to :user, index: true
    	t.string 	:long_link
    	t.string 	:short_link
    	t.integer 	:acess_count, :default => 0
      t.timestamps
    end
  end
end
