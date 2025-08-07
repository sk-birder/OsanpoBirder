class Public::MapsController < ApplicationController
  def index
    byebug
    # これはindexアクションのインスタンス、その冒頭です
    # 地図関連
    respond_to do |format|
      # リクエストされるフォーマットがHTML形式の場合
      format.html do
        @map_tests_in_view = MapTest.all
      end
      # リクエストされるフォーマットがJSON形式の場合
      # jsonへの変換はjbuilderというGemで行う
      format.json do
        byebug
        # これはindexアクションのインスタンスです
        @map_tests = MapTest.all
      end
    end
  end

  def show
    byebug
    # これはshowアクションのインスタンス、その冒頭です
    # 地図関連
    respond_to do |format|
      # リクエストされるフォーマットがHTML形式の場合
      format.html do
        @map_test_in_view = MapTest.find(params[:id])
      end
      # リクエストされるフォーマットがJSON形式の場合
      # jsonへの変換はjbuilderというGemで行う
      format.json do
        byebug
        # これはshowアクションのインスタンスです
        @map_test = MapTest.find(params[:id])
      end
    end
  end

end
