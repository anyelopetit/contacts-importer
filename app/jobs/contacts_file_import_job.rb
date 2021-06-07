class ContactsFileImportJob < ApplicationJob
  queue_as :default

  def perform(contacts_file_id)
    contacts_file = ContactsFile.find(contacts_file_id)
    user = contacts_file.user
    file = contacts_file.file.download
    headers = contacts_file.headers || 'name,birth_date,phone,address,credit_card,franchise,email'

    # use the csv gem to create csv table
    csv = CSV.parse(file, headers: true)
    include_headers = csv.headers == csv.as_json.first
    rows = csv.as_json - [csv.headers]

    contacts_file.update(excel_rows: rows.size, include_headers: include_headers)
    contacts_file.running!

    # loop through each table row and do something with the data
    csv.as_json.each_with_index do |row, index|
      next if index.zero? && contacts_file.include_headers

      data = row.size > 1 ? row : row.first.split(',')

      contact_params = Hash[[headers.split(','), data].transpose]
      contact = user.contacts.new(contact_params)
      byebug
      row_params = {
        row: index + 1,
        data_row: contact_params,
        contacts_file_id: contacts_file.id
      }
      if contact.save
        row_params.merge!(reviewable_id: contact.id, status: 1)
      else
        row_params.merge!(save_errors: contact.errors.full_messages)
      end
      ContactsFileRow.create!(row_params)
    end

    file_status = contacts_file.rows.where(status: 1).present? ? 1 : 2
    contacts_file.update(status: file_status)

    contacts_file.update(finished_at: DateTime.current)
  end
end
