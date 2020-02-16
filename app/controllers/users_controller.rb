class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers] #index、edit、update、destroyアクションにはログインしないといけない。
  before_action :correct_user,   only: [:edit, :update] #ログインしているユーザーのみ編集、更新ができる
  before_action :admin_user,     only: :destroy #管理者だけがユーザー削除できる

  # GET /users/:id

  def show
      end
  
  
  def index
      @users = User.paginate(page: params[:page]).search(params[:search]) #Userテーブルのデータを全て表示
end


  def show
    @user = User.find(params[:id])                                         #findはモデルの検索機能を持つメソッド。モデルと紐づいているデータベースのテーブルからレコードを1つ取り出す際に使う。
    @microposts = @user.microposts.paginate(page: params[:page])       #paramsはRails（route?）で送られてきた値を受け取るためのメソッド。get、post、formを使って送信される。 #params[:カラム名]
    


    # => app/views/users/show.html.erb
    # debugger
  end

  def new
    @user = User.new
    # => form_for @user
  end

  def edit
    @user = User.find(params[:id]) #UsersControllerのインスタンス変数@user（@から始めるのは決まり事）を作成してeditメソッドを呼び出す。
                                   #インスタンス変数を経由することでControllerからViewへ変数を渡すことができる。
  end


  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save # => Validation
       @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      # Failure
      render 'new'
    end
  end

 def update
   @user = User.find(params[:id])
   if @user.update_attributes(user_params) #update_attributesはデータベースのレコードを複数同時に更新する。validationも実行される。
     flash[:success] = "Profile updated"
     redirect_to @user #
  else
    render'edit'
   end
  end

 def destroy
   User.find(params[:id]).destroy #findメソッドとdestroyメソッドを1行で書くために連結している
   flash[:success] = "User deleted"
   redirect_to users_url
 end

 def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end


  private


  def user_params
    params.require(:user).permit(
      :name, :email, :password,
      :password_confirmation)
  end

  # beforeアクション


  # 正しいユーザーかどうか確認
  def correct_user
    @user = User.find(params[:id])
     redirect_to(root_url) unless current_user?(@user)
  end

  # 管理者かどうか確認
  def admin_user
   redirect_to(root_url) unless current_user.admin?
  end



    end
