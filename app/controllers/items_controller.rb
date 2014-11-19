class ItemsController < ApplicationController
  before_action :find_resource, only: [:edit, :update]

  def index
    @items      = Item.all
    @categories = Category.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to @item
    else
      render :new
    end
  end

  def update
    @item.update(item_params)

    redirect_to item_path(@item)
  end

  def edit
  end

  private

  def item_params
    params.require(:item).permit(:title, :description, :price)
  end
end
