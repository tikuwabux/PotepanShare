class RoomsController < ApplicationController

  def new
    @room = Room.new
  end

  def create
    # room_params は 下端で定義しているprivateメソッド
    # Roomオブジェクトのuser_idカラム値は､ログイン中Userオブジェクトのidカラム値と一致させたい｡
    # だから､Reservationモデルを介した関連を利用しない方法で､後者を前者に渡し､下の記述で受け取っている｡
    @room = Room.new(room_params)
    # 生成したroomインスタンスをDBへ保存することが成功した時
    if @room.save
      flash[:notice] = "ルームの新規登録に成功しました"

      # room_path(id値) で 登録済みルーム詳細ページ(/rooms/id値)へ
      redirect_to room_path(@room.id)
    else
      # validateエラーメッセージを配列として取得し､変数flashに格納｡
      flash[:validate_error_messages] = @room.errors.full_messages

      flash[:notice] = "ルームの新規登録に失敗しました"
      # newアクションへ
      render "new"
    end
  end

  def show
    # Room.find(params[:id]) で､idカラム値がparams[:id]であるroomレコードを取得
    @room = Room.find(params[:id])

    # ルーム詳細ページに､ルーム予約フォームを入れたいので､その作成に使うReservationインスタンス(値はまだ空)を生成｡
    @reservation = Reservation.new
  end

  def index
    # Room.where(user_id: current_user.id) で､
    # user_id値が､現在ログインしているユーザーのid値であるRoomレコードを取得(複数可)
    @rooms = Room.where(user_id: current_user.id)

    #rooms = current_user.rooms という関連を使った記述でも可
  end

  # room検索フォーム1 (検索条件 == 住所名 && 単数単語)(シンプルモード)の検索結果表示ページに対応
  def address_search

    @search = Room.ransack(params[:q])
    # (room検索フォーム1作成時に､ params[:q] = {:address_cont => 'フォームの入力値'} と設計したので)
    #       = Room.ransack({:address_cont => 'フォームの入力値'})
    #       => Ransack::Search<class: Room, base: Grouping <conditions: [Condition <attributes: ["address"], predicate: cont, values: ["フォームの入力値"]>], combinator: and>>

    # .resultで､ransackメソッドで取得したデータをActiveRecord_Relationのオブジェクトに変換｡
    @search_rooms = @search.result

    # オブジェクトを取得するまでに､どんなPostgreSQLクエリを発行したのか､以下で確認
    # @search_rooms.sql => SELECT "rooms".* FROM "rooms" WHERE "rooms"."address" ILIKE '%東京%'
    # roomsテーブルから､addressカラム値が '%フォームの入力値%'である部分一致のILIKE検索(大文字小文字を個別しないLIKE検索)を実行し､該当レコードを取得という内容
  end

  # room検索フォーム2 (検索条件 == ルーム名 && (単数単語 || 複数単語) )(アドバンストモード)の検索結果表示ページに対応
  def freeword_name_search
    # 具体例として､ "お  菓子 家" とフォームに入力後､送信ボタン押下時､
    # つまり､params[:q][:name_cont] == "お  菓子 家" の時､に実行される処理を 1→2→3→4→5 で示す

    #以下2行で groupings属性に渡す値を設計する｡

    # .split(全角･半角スペースの正規表現)で､入力値(文字列)を半角・全角スペース区切りで配列に変換
    keywords = params[:q][:name_cont].split(/[\p{blank}\s]+/)
    #1       = "お  菓子 家".split(/[\p{blank}\s]+/)
    #        => ["お", "菓子", "家"]

    # reduceを使って､keywords(文字列(複数可)を要素にもつ配列)を､grouping_array(条件(複数可､ハッシュ構造)をもつ配列)に変換する｡
    grouping_array = keywords.reduce([]){ |array, word| array << { name_cont: word } }
    #2             = ["お", "菓子", "家"].reduce([]){ |array, word| array << { name_cont: word } }
    #              => [{:name_cont=>"お"}, {:name_cont=>"菓子"}, {:name_cont=>"家"}]

    # 設計したgrouping_arrayの条件でAND検索を実行
    @search = Room.ransack({ combinator: 'and', groupings: grouping_array })
    #3      = Room.ransack({ combinator: 'and', groupings: [{:name_cont=>"お"}, {:name_cont=>"菓子"}, {:name_cont=>"家"}] })
    #       => Ransack::Search<class: Room, base: Grouping <combinator: and, groupings: [
    #                                                                                    Grouping <conditions: [Condition <attributes: ["name"], predicate: cont, values: ["お"]>]>,
    #                                                                                    Grouping <conditions: [Condition <attributes: ["name"], predicate: cont, values: ["菓子"]>]>,
    #                                                                                    Grouping <conditions: [Condition <attributes: ["name"], predicate: cont, values: ["家"]>]>
    #                                                                                    ] >>

    @search_rooms = @search.result
    #4 => [#<Room:0x00000001629ee450 id: 8, name: "お菓子の家", introduction: "お菓子の家です", price: 1000, address: "東京大田区東武練馬", user_id: 4, created_at: Sat, 26 Nov 2022 22:07:02 UTC +00:00, updated_at: Sat, 26 Nov 2022 22:07:02 UTC +00:00>]

    #5 オブジェクトを取得するまでに､どんなPostgreSQLクエリを発行したのか､以下で確認
    # @search_rooms.sql => SELECT "rooms".* FROM "rooms" WHERE ("rooms"."name" ILIKE '%お%' AND "rooms"."name" ILIKE '%菓子%' AND "rooms"."name" ILIKE '%家%')
    # roomsテーブルから､nameカラム値が '%お%' かつ '%菓子%' かつ %家% である部分一致のILIKE検索を実行し､該当レコードを取得という内容｡
  end

  private
  # params を使用し､ルーム情報登録ページの送信ボタン押下､ルーム情報編集ページの編集ボタン押下によって送られたきたデータを取得｡
  # 尚､require,permitメソッドで､roomオブジェクトのname･introduction・price･address・image･user_id属性以外の取得データを弾く｡(Strong Parameters)
  def room_params
    params.require(:room).permit(:name, :introduction, :price, :address, :image, :user_id)
  end
end
