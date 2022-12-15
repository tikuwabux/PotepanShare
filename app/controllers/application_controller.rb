class ApplicationController < ActionController::Base
  # 全コントローラーの全アクションに対応するviewファイルで､room検索フォームを作成可能にする
  before_action :prepare_room_search_form

  # room検索フォームを作成するために必要な(search_form_forの引数となる)searchオブジェクトを生成し､格納
  def prepare_room_search_form
    @search = Room.ransack(params[:q])

    # @searchオブジェクトのクラスを確認
    # @search.class => Ransack::Search
  end
end
