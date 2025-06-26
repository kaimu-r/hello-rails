class Admin::DepartmentsController < Admin::BaseController
  # 部署一覧ページ
  def index
    @departments = Department.all
  end

  # 部署詳細ページ
  def show
    @department = Department.find(params[:id])
    @users = @department.users
  end

  # 部署新規作成ページ
  def new
    @department = Department.new
  end

  # 部署編集ページ
  def edit
    @department = Department.find(params[:id])
  end

  # 新規部署作成
  def create
    @department = Department.new(department_params)

    if @department.save
      redirect_to admin_department_url(@department)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # 部署更新
  def update
    @department = Department.find(params[:id])

    # 部署の更新処理を行う
    if @department.update(department_params)
      redirect_to admin_department_url(@department)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # 部署削除
  def destroy
    @department = Department.find(params[:id])
    @department.destroy

    redirect_to admin_departments_path, status: :see_other
  end

  private
    def department_params
      params
        .require(:department)
        .permit(:name)
    end
end
