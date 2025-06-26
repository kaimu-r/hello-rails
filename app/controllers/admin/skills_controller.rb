class Admin::SkillsController < ApplicationController
  # スキル一覧ページ
  def index
    @skills = Skill.all
  end

  # スキル詳細ページ
  def show
    @skill = Skill.find(params[:id])
    @users = @skill.users
  end

  # スキル新規作成ページ
  def new
    @skill = Skill.new
  end

  # スキル編集ページ
  def edit
    @skill = Skill.find(params[:id])
  end

  # 新規スキル作成
  def create
    @skill = Skill.new(skill_params)

    if @skill.save
      redirect_to admin_skill_url(@skill)
    else
      render :new, status: :unprocessable_entity
    end
  end

  # スキル更新
  def update
    @skill = Skill.find(params[:id])

    # スキルの更新処理を行う
    if @skill.update(skill_params)
      redirect_to admin_skill_url(@skill)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # スキル削除
  def destroy
    @skill = Skill.find(params[:id])
    @skill.destroy

    redirect_to admin_skills_path, status: :see_other
  end

  private
    def skill_params
      params
        .require(:skill)
        .permit(:name)
    end
end
