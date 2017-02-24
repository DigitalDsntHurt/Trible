class MashupsController < ApplicationController
  before_action :set_mashup, only: [:show, :edit, :update, :destroy]
  http_basic_authenticate_with name: ENV['MASHUPS_ADMIN_UNAME'], password: ENV['MASHUPS_ADMIN_PASS']
  # GET /mashups
  # GET /mashups.json
  def index
    @mashups = Mashup.all
  end

  # GET /mashups/1
  # GET /mashups/1.json
  def show
  end

  # GET /mashups/new
  def new
    @mashup = Mashup.new
  end

  # GET /mashups/1/edit
  def edit
  end

  # POST /mashups
  # POST /mashups.json
  def create
    @mashup = Mashup.new(mashup_params)

    respond_to do |format|
      if @mashup.save
        format.html { redirect_to @mashup, notice: 'Mashup was successfully created.' }
        format.json { render :show, status: :created, location: @mashup }
      else
        format.html { render :new }
        format.json { render json: @mashup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mashups/1
  # PATCH/PUT /mashups/1.json
  def update
    respond_to do |format|
      if @mashup.update(mashup_params)
        format.html { redirect_to @mashup, notice: 'Mashup was successfully updated.' }
        format.json { render :show, status: :ok, location: @mashup }
      else
        format.html { render :edit }
        format.json { render json: @mashup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mashups/1
  # DELETE /mashups/1.json
  def destroy
    @mashup.destroy
    respond_to do |format|
      format.html { redirect_to mashups_url, notice: 'Mashup was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_tweet_to_true
    mashup = Mashup.find(params[:id])
    mashup.update(tweet?: true)
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mashup
      @mashup = Mashup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mashup_params
      params.require(:mashup).permit(:index)
    end

end
