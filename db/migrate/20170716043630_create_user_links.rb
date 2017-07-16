class CreateUserLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :user_links do |t|
    	t.belongs_to :link, index: true
    	t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
