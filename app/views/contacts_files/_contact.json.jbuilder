json.extract! contacts_file, :id, :name, :birth_date, :phone, :address, :credit_card, :franchise, :email, :user_id, :created_at, :updated_at
json.url contacts_file_url(contacts_file, format: :json)
