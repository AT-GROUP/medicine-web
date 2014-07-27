class MainController < ApplicationController
  def index
    @mapCords = [55.34, 37.17]
    @mapZoom = 7
  end
end
