class ContactsFile < ApplicationRecord
  # == Constants ============================================================
  VALID_FILE_NAMES = [/[^a-z0-9\-]+/i].freeze

  # == Attributes ===========================================================

  # == Extensions ===========================================================

  # == Relationships ========================================================
  belongs_to :user
  has_many :rows, foreign_key: 'contacts_file_id', class_name: 'ContactsFileRow' , dependent: :destroy

  has_one_attached :file

  # == Validations ==========================================================
  validates :file,
            attached: true,
            content_type: %i[csv],
            size: { less_than: 1.megabytes }

  # == Scopes ===============================================================

  # == Enums ================================================================
  enum status: { running: 0, finished: 1, failed: 2 }
end
