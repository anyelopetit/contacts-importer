class Contact < ApplicationRecord
  # == Constants ============================================================
  EDITABLE_FIELDS = %i[name birth_date phone address credit_card franchise email].freeze
  HEADERS = Hash[[EDITABLE_FIELDS.map { |x| x.to_s.titleize }, EDITABLE_FIELDS].transpose]

  # == Relationships ========================================================
  belongs_to :user

  # == Validations ==========================================================
  validates_presence_of EDITABLE_FIELDS
  validates_uniqueness_of :email, scope: %i[user_id]
  # validates :name, presence: true, format: /(?<name>\w+)/
  # validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
end
