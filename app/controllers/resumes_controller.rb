class ResumesController < ApplicationController
  before_action :set_resume, only: %i[ show edit update destroy ]
  after_action :test_resume, only: %i[create]
  # GET /resumes or /resumes.json
  require 'prawn'
  require 'pdf/toolkit'
  require "origami"
  require 'prawn-styled-text'
  require 'barby'
  require 'barby/barcode/code_128'
  require 'barby/outputter/ascii_outputter'
  require 'barby/outputter/png_outputter'
  require 'open-uri'
  require 'chunky_png'

  def index
    @resumes = Resume.all
  end

  # GET /resumes/1 or /resumes/1.json

  def show
    # binding.pry
    active_storage_disk_service = ActiveStorage::Service::DiskService.new(root: Rails.root.to_s + '/storage/')
    path = active_storage_disk_service.send(:path_for, @resume.file.blob.key)
    my_pdf = PDF::Toolkit.open(path)
    @text = my_pdf.to_text.read.split(/\n+/)
    # binding.pry
    @barcode = Barby::Code128B.new(@text[20])
    @blob = Barby::PngOutputter.new(@barcode).to_png
    respond_to do |format|
      format.html
      format.png do
        send_data @blob, type: "image/png", disposition: "inline"
      end
    end

    # post.barcode.attach(blob)
  end

  # GET /resumes/new
  def new
    @resume = Resume.new
  end

  # GET /resumes/1/edit
  def edit
  end
  def test_resume
    # binding.pry
    #  @a
    # template_filename = a["file"].path
    # binding.pry
    # my_pdf = PDF::Toolkit.open(template_filename)
    # @text = my_pdf.to_text.read.split(/\n+/)
  end


  # POST /resumes or /resumes.json
  def create
    @resume = Resume.new(resume_params)
    binding.pry
    @a = params[:resume]
    # test_resume(a)
    template_filename = @a["file"].path
    #       prawn_filename = 'temp.pdf'
    #       output_filename = 'output.pdf'
    #       Prawn::Document.generate(prawn_filename) do
    #         binding.pry

    #         # draw_text "Hello World", color: "red", :at => [100, 12]
    #          bounding_box([200,cursor], :width => 350, :height => 80) do
    #     stroke_bounds
    #     stroke do
    #         stroke_color 'FFFF00'
    #         fill_color '000000'
    #         fill_and_stroke_rounded_rectangle [cursor-80,cursor], 350, 80, 10
    #         fill_color '000000'
    #         text_box "Signature________", color: "FF6464", align: :right

    #     end
    # end
    #           puts page.text
          # end
          # my_pdf = PDF::Toolkit.open(template_filename)
          # text = my_pdf.to_text.read.split(/\n+/)
          # PDF::Toolkit.pdftk(prawn_filename, "background", template_filename, "output", output_filename)
    #       reader = PDF::Reader.new(pdf_path)
          # reader.pages.each do |page|
          #     reader.page.text.gsub('Download your free personal shopping assistant at meet.shop.app',a["dynamic_data"])
          #     puts page.text
          # end
    #       Prawn::Document.generate("hello.pdf") do
    #       reader.pages[6].text.gsub('Download your free personal shopping assistant at meet.shop.app',a["dynamic_data"])
    #       end

    respond_to do |format|
      if @resume.save
        format.html { redirect_to resume_url(@resume), notice: "Resume was successfully created." }
        format.json { render :show, status: :created, location: @resume }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /resumes/1 or /resumes/1.json
  def update
    respond_to do |format|
      if @resume.update(resume_params)
        format.html { redirect_to resume_url(@resume), notice: "Resume was successfully updated." }
        format.json { render :show, status: :ok, location: @resume }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @resume.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /resumes/1 or /resumes/1.json
  def destroy
    @resume.destroy

    respond_to do |format|
      format.html { redirect_to resumes_url, notice: "Resume was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resume
      @resume = Resume.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def resume_params
      params.require(:resume).permit(:name, :static_data, :dynamic_data, :file)
    end
end
