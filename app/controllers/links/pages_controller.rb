class Links::PagesController < PagesController
  before_action :set_categories, only: :index

  def index
    pages  = Comfy::Cms::Page.includes(:site).published.filter(params.slice(:category))
    pages  = Comfy::Cms::Search.new(pages, params[:search]).results if params[:search].present?

    @pages = PageMirror.collect(pages)
  end
end
