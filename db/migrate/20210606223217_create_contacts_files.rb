class CreateContactsFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts_files do |t|
      t.integer :status
      t.datetime :finished_at
      t.integer :excel_rows
      t.string :headers
      t.boolean :include_headers
      t.references :user

      t.timestamps
    end
  end
end
