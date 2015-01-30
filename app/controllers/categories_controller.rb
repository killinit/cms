class CategoriesController < Comfy::Admin::Cms::BaseController
  before_action :find_category, only: [:show, :update, :destroy]

  def index
    @primary_navigation, @secondary_navigation = Comfy::Cms::Category.navigation_categories
  end

  def show
    @pages = Comfy::Cms::Page.in_category(@category.id)
  end

  def update
    CategoryService.new(@category, category_params, params).update_category!
    redirect_to action: :show
  end

  def new
    @category = Comfy::Cms::Category.new
  end

  def create
    @category = Comfy::Cms::Category.new(category_params)
    if @category.save
      redirect_to category_path(@category)
    else
      render :new
    end
  end

  def destroy
    @category.destroy
    redirect_to action: :index
  end

  private

  def category_params
    params.require(:comfy_cms_category).permit(
      :label,
      :parent_id,
      :title_en,
      :title_cy,
      :description_en,
      :description_cy,
      :ordinal,
      :navigation,
      :site_id,
      :categorized_type
    )
  end

  def find_category
    @category = Comfy::Cms::Category.find(params[:id])
  end
end