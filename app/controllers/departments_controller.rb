class DepartmentsController < ApplicationController
  before_action :set_department, only: %i[ show edit update destroy ]

  # GET /departments or /departments.json
  def index
    @q = Department.ransack(params[:q])
    @departments = @q.result(distinct: true)
  end

  # GET /departments/1 or /departments/1.json
  def show
    @users = User.where.not(id: @department.member_users.map(&:id))
#    @users = User.where.not(id: @department.member_users.map{|user| user.id})
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments or /departments.json
  def create
    @department = Department.new(department_params)

    respond_to do |format|
      if @department.save
        format.html { redirect_to @department, notice: I18n.t('scaffold.department.create') }
        format.json { render :show, status: :created, location: @department }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /departments/1 or /departments/1.json
  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to @department, notice: I18n.t('scaffold.department.update') }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /departments/1 or /departments/1.json
  def destroy
    @department.destroy
    respond_to do |format|
      format.html { redirect_to departments_url, notice: I18n.t('scaffold.department.destroy') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def department_params
      params.require(:department).permit(:name, :location, :description, :leader)
    end
end
