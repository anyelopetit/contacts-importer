class ContactsFileRow < ApplicationRecord
  # == Relationships ========================================================
  belongs_to :contacts_file
  belongs_to :reviewable, polymorphic: true

  # == Validations ==========================================================
  validates_uniqueness_of :row, scope: %i[contacts_file_id]

  # == Enums ================================================================
  enum status: { failed: 0, succeeded: 1 }
  enum action: { creating: 0, updating: 1, deleting: 2 }
end
