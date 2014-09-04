class ColoursController < ApplicationController
  before_action :set_colour, only: [:show, :edit, :update, :destroy]

  # GET /colours
  # GET /colours.json
  def index
    @colours = Colour.all
  end

  # GET /colours/1
  # GET /colours/1.json
  def show
  end

  # GET /colours/new
  def new
    @colour = Colour.new
  end

  # GET /colours/1/edit
  def edit
  end

  # POST /colours
  # POST /colours.json
  def create
    @colour = Colour.new(colour_params)

    respond_to do |format|
      if @colour.save
        format.html { redirect_to @colour, notice: 'Colour was successfully created.' }
        format.json { render :show, status: :created, location: @colour }
      else
        format.html { render :new }
        format.json { render json: @colour.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /colours/1
  # PATCH/PUT /colours/1.json
  def update
    respond_to do |format|
      if @colour.update(colour_params)
        format.html { redirect_to @colour, notice: 'Colour was successfully updated.' }
        format.json { render :show, status: :ok, location: @colour }
      else
        format.html { render :edit }
        format.json { render json: @colour.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /colours/1
  # DELETE /colours/1.json
  def destroy
    @colour.destroy
    respond_to do |format|
      format.html { redirect_to colours_url, notice: 'Colour was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  
  # Use callbacks to share common setup or constraints between actions.
  def set_colour
    @colour = Colour.find(params[:id])
    @new = Colour.new
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def colour_params
    params[:colour]
  end
end
