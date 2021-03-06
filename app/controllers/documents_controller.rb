class DocumentsController < ApplicationController
  include ActionController::Streaming
  include Zipline
  before_action :set_document, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[new edit update destroy]

  # GET /documents or /documents.json
  def index

#    @documents = Document.all
    @q = Document.ransack(params[:q])
    @documents = @q.result(distinct: true)

    respond_to do |format|
      format.html
      format.zip do
#        byebug
        files =  @documents.where.not(filepath: nil).map{ |document| [document.filepath, "#{document.title}.pdf"] }
        zipline(files, 'documents.zip')
      end
    end
  end

  # GET /documents/1 or /documents/1.json
  def show
#    byebug
  end

  # GET /documents/new
  def new
    @document = Document.new
    products = Product.all
    @product_choice = []
    products.each do |product|
      @product_choice << [product.name, product.id]
    end
  end

  # GET /documents/1/edit
  def edit
    products = Product.all
    @product_choice = []
    products.each do |product|
      @product_choice << [product.name, product.id]
    end
  end

  # POST /documents or /documents.json
  def create
    @document = Document.new(document_params)
#    byebug
    @document.product_id = document_params[:product_id] #入力時に選択した製品のidを、documentの外部 key として記録
    @document.user_id = current_user.id #docmentをcreateするuserのidを、作成者としてuser_id(FK)に記録
    respond_to do |format|
      if @document.save
        format.html { redirect_to @document, notice: I18n.t('scaffold.document.create') }
        format.json { render :show, status: :created, location: @document }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /documents/1 or /documents/1.json
  def update
    @document.product_id = document_params[:product_id] #入力時に選択した製品のidを、documentの外部 key として記録
    respond_to do |format|
      if @document.update(document_params)
        format.html { redirect_to @document, notice: I18n.t('scaffold.document.update') }
        format.json { render :show, status: :ok, location: @document }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /documents/1 or /documents/1.json
  def destroy
    @document.destroy
    respond_to do |format|
      format.html { redirect_to documents_url, notice: I18n.t('scaffold.document.destroy') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_document
      @document = Document.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def document_params
      params.require(:document).permit(:title, :content, :product_id, :filepath, :category, :control_number, :authorize)
    end
end
