class StaticPagesController < ApplicationController
  def home
    if logged_in?
   @micropost  = current_user.microposts.build
      if params[:q]
        relation = Micropost.joins(:user)
        @feed_items = relation.merge(User.search_by_keyword(params[:q]))
                        .or(relation.search_by_keyword(params[:q]))
                        .paginate(page: params[:page]) #feed_itemsの定義。
        else
      @feed_items = current_user.feed.paginate(page: params[:page])
      end

    end
  end
    # app/views/リソース名/アクション名.html.erb
    # app/views/static_pages/home.html.erb


  def help
  end

  def about
    # 'app/views/static_pages/about.html.erb'
  end

  def contact
    # app/views/static_pages/contact.html.erb'
  end
end
