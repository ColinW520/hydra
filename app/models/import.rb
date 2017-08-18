class Import < ApplicationRecord
  self.inheritance_column = :_type_disabled

  has_one :creator, class_name: 'User', foreign_key: :created_by
  belongs_to :organization

  validates :type, presence: true
  validates :organization, presence: true

  has_attached_file :datafile,
    dependent: :destroy,
    path: '/hydra_imports/:hash-:id.:extension',
    hash_secret: 'a92342be23ad9827634654a5617646'

  validates_attachment :datafile, content_type: {
    content_type: [
      'text/plain',
      'text/csv',
      'application/vnd.ms-excel',
      'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
      ]
    }

  after_create :start_processing
  def start_processing
    Imports::ImportStartingWorker.perform_async(self.id)
    Imports::ImportStartingWorker.new.perform(self.id)
  end
end
