class ImportFilesController < ApplicationController

  # GET /import_files
  def index
  end

  # GET /import_files/new
  def new
    @import_file = ImportFile.new
  end

  # POST /import_files
  def create
    @import_file = ImportFile.new(import_file_params)
    
    if @import_file.import
      flash[:results] = @import_file.results
      redirect_to import_files_path, notice: "Processed #{@import_file.processed_rows} rows in '#{@import_file.filename}'."
    else
      render action: 'new'
    end
  end

private

  def import_file_params
    params.fetch(:import_file, {}).permit(:file)
  end
end
