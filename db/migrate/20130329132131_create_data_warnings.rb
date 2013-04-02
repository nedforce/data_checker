class CreateDataWarnings < ActiveRecord::Migration
  def change
    create_table :data_warnings do |t|
      t.integer :subject_id
      t.string  :subject_type
      t.string  :error_code
      t.text    :message
      t.string  :status
      t.timestamps
    end
    
    add_index :data_warnings, [:subject_id, :subject_type]
    add_index :data_warnings, :error_code
    add_index :data_warnings, :status    
  end
end
