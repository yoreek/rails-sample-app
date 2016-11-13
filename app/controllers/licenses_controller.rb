# Licenses controller
class LicensesController < ApplicationController
  before_action :set_license, except: [:index, :create]
  respond_to :html, :json

  def index
    @license = License.all
    respond_with do |format|
      format.json { render json: @license.as_json }
      format.html
    end
  end

  def create
    @license = License.new(license_params)
    p license_params
    if @license.save
      render json: @license.as_json, status: :ok
    else
      render json: { license: @license.errors }, status: :unprocessable_entity
    end
  end

  def show
    respond_with(@license.as_json(include: [:license_fees, :license_mappings]))
  end

  def update
    if @license.update_attributes(license_params)
      render json: @license.as_json, status: :ok
    else
      render json: { license: @license.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    @license.destroy
    render json: { status: :ok }
  end

  private

  def license_params
    license = params.require(:license)

    %w(license_fees license_mappings).each do |name|
      next if license[name].blank?
      license[name + '_attributes'] = license[name]
      license.delete(name)
    end

    license.permit(:name, :licensing_type, :sku, :licensor_id,
                   license_fees_attributes: [
                     :id, :amount, :start_date, :license_id, :_destroy
                   ],
                   license_mappings_attributes: [
                     :id, :mappable_id, :mappable_type, :license_id, :_destroy
                   ])
  end

  def set_license
    @license = License.find(params[:id])
    render json: { status: :not_found } unless @license
  end
end
