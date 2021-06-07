class ContactsFilesController < ApplicationController
  before_action :set_contacts_file, only: %i[ show edit update destroy ]

  # GET /contacts_files or /contacts_files.json
  def index
    @contacts_files = current_user.contacts_files.all
  end

  # GET /contacts_files/1 or /contacts_files/1.json
  def show; end

  # GET /contacts_files/new
  def new
    @contacts_file = ContactsFile.new
  end

  # POST /contacts_files or /contacts_files.json
  def create
    file = contacts_file_params[:file]
    file_type = file.present? ? file.path.split('.').last.to_s.downcase : ''
    if file.present? && %w[csv].include?(file_type)
      @contacts_file = current_user.contacts_files.new(contacts_file_params)

      if @contacts_file.save
        ContactsFileImportJob.perform_now(@contacts_file.id)
        flash[:notice] = 'Uploading file'
      else
        flash[:error] = 'File was not saved'
      end
    else
      flash[:error] = 'File is not supported'
    end
    redirect_to contacts_files_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_contacts_file
    @contacts_file = ContactsFile.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def contacts_file_params
    params.require(:contacts_file).permit(
      :file, :headers, :include_headers
    )
  end
end
