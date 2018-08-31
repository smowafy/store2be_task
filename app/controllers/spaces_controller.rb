# frozen_string_literal: true

class SpacesController < ApplicationController
  before_action :set_store, except: %i[price_quote]
  before_action :set_spaces, only: %i[index]
  before_action :set_space, only: %i[show update destroy]
  before_action :validate_price_quote_params, only: %i[price_quote]

  # GET /spaces
  def index
    render json: SpacesDecorator.decorate(@spaces).to_json
  end

  # GET /spaces/1
  def show
    render json: @space.decorate.to_json
  end

  # POST /spaces
  def create
    @space = Space.new(space_params)

    if @space.save
      render json: @space.decorate.to_json, status: :created, location: store_space_url(@store, @space)
    else
      render json: @space.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /spaces/1
  def update
    if @space.update(space_params)
      render json: @space.decorate.to_json
    else
      render json: @space.errors, status: :unprocessable_entity
    end
  end

  # DELETE /spaces/1
  def destroy
    @space.destroy
  end

  def price_quote
    space = Space.find(params[:id])

    render json: { price: space.price_quote(@start_date, @end_date) }
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_store
    @store = Store.find(params[:store_id])
  end

  def set_spaces
    spaces = @store.spaces

    filters = query_param_filters

    if filters.blank?
      @spaces = spaces
    else
      ar_conditions = Space.parse_query(filters.to_h)
      @spaces = spaces.where(ar_conditions)
    end
  rescue Space::InvalidQuery => e
    render json: { message: e.message }, status: :unprocessable_entity
  end

  def set_space
    @space = @store.spaces.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def space_params
    parameters = params.require(:space)
                       .permit(:title, :size, :price_per_day, :price_per_week, :price_per_month)
    parameters[:store_id] = params[:store_id]
    parameters
  end

  def query_param_filters
    params.permit(:title, :size, :price_per_day, :price_per_week, :price_per_month)
  end

  def validate_price_quote_params
    @start_date, @end_date = [params[:start_date], params[:end_date]].map do |date|
      case validate_date(date)
      when :unix
        Time.at(date.to_i)
      when :date
        Time.parse(date)
      when :invalid
        return render json: { message: 'Invalid dates provided' }, status: :unprocessable_entity
      end
    end
  end

  def validate_date(date_string)
    # To determine if the provided is a unix timestamp
    return :unix if date_string.to_i.to_s == date_string
    begin
      Time.parse(date_string)
    rescue ArgumentError
      return :invalid
    end
    :date
  end
end
