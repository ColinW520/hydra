class LegalDocsController < ApplicationController
  before_filter :find_legal_doc, except: [:index, :new, :create]

  def new
    @legal_doc = LegalDoc.new()
  end

  def create
    @legal_doc = LegalDoc.create(legal_doc_params)

    respond_to do |format|
      if @legal_doc.save
        format.json { head :no_content }
        format.js { flash[:success] = 'Legal Doc has been created.' }
        format.html {
          flash[:success] = 'Legal Doc has been created.'
          redirect_to legal_doc_path
        }
      else
        format.json { render json: @solution.errors.full_messages, status: :unprocessable_entity }
      end
    end
  end

  def index
    redirect_to legal_doc_path(LegalDoc.where(type: params[:type], is_default: true).last)
  end
  
  def show
  end

  private

  def find_legal_doc
    @legal_doc = LegalDoc.find(params[:id])
  end
end
