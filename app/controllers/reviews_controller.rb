class ReviewsController < ApplicationController
  before_action :set_review, only: %i[ show edit update destroy ]

  # GET /reviews or /reviews.json
  def index
    products = Product.all
    @product_choice = []
    products.each do |product|
      @product_choice << [product.name, product.id]
    end

    @q = Review.ransack(params[:q])
    @reviews = @q.result(distinct: true)
  end

  # GET /reviews/1 or /reviews/1.json
  def show
    @users = User.where.not(id: @review.reviewer_users.map{|user| user.id})
    @documents = Document.where(product_id: @review.product_id).where.not(id: @review.review_documents.map{|d| d.document_id})
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        format.html { redirect_to @review, notice: I18n.t('scaffold.review.create') }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    if params[:review][:judge] == "承認済"
      @review.review_document_documents.each do |document|
        document.update(authorize: "承認済")
      end
    end
    respond_to do |format|
      if @review.update(review_params)
        format.html { redirect_to @review, notice: I18n.t('scaffold.review.update') }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review.destroy
    respond_to do |format|
      format.html { redirect_to reviews_url, notice: I18n.t('scaffold.review.destroy') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_review
      @review = Review.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def review_params
      params.require(:review).permit(:product_id, :project_id, :requester, :stage, :description, :former_review, :date_on, :deadline, :judge, :comment)
    end
end
