# frozen_string_literal: true

class StoresController < ApplicationController
  before_action :set_store, only: %i[show update destroy]
  before_action :set_stores, only: %i[index]

  # GET /stores
  def index
    render json: StoresDecorator.decorate(@stores).to_json
  end

  # GET /stores/1
  def show
    render json: @store.decorate.to_json
  end

  # POST /stores
  def create
    @store = Store.new(store_params)

    if @store.save
      render json: @store.decorate.to_json, status: :created, location: @store
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /stores/1
  def update
    if @store.update(store_params)
      render json: @store.decorate.to_json
    else
      render json: @store.errors, status: :unprocessable_entity
    end
  end

  # DELETE /stores/1
  def destroy
    @store.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_store
    @store = Store.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def store_params
    params.require(:store).permit(:title, :city, :street, :spaces_count)
  end

  def query_param_filters
    params.permit(:title, :city, :street, :spaces_count)
  end

  def set_stores
    filters = query_param_filters

    if filters.blank?
      @stores = Store.all
    else
      ar_conditions = Store.parse_query(filters.to_h)
      @stores = Store.where(ar_conditions)
    end
  rescue Store::InvalidQuery => e
    render json: { message: e.message }, status: :unprocessable_entity
  end
end
