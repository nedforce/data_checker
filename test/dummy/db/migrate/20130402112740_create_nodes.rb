class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :title
      t.text :body
      t.text :body2
      t.datetime :last_checked_at
    end
  end
end
