class CreateContactsFileRows < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts_file_rows do |t|
      t.references :contacts_file, null: false, foreign_key: true
      t.references :reviewable, polymorphic: true, null: false
      t.integer :row
      t.integer :status
      t.integer :action
      t.jsonb :data_before
      t.jsonb :data_row
      t.jsonb :save_errors

      t.timestamps
    end
  end
end
