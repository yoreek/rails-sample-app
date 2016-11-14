# Licenses controller
class LicensesController < ApplicationController
  before_action :set_license, except: [:index, :create]
  respond_to :html, :json, :xls

  def index
    respond_with do |format|
      format.json { render json: License.all.as_json }
      format.html
      format.xls {
        period = report_period
        @results = ActiveRecord::Base.connection.select_all(
          ActiveRecord::Base.send(:sanitize_sql_array, [report_query, *period])
        ).to_hash
      }
    end
  end

  def create
    @license = License.new(license_params)
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

  def report_period
    from = Date.parse(params.require(:from) + '-01').to_s
    to = Date.parse(params.require(:to) + '-01').end_of_month.to_s
    [from, to]
  end

  def report_query
    <<~SQL
      SELECT lr.name as licensor, l.name as license, a.name as account,
             SUM(c.amount) as charges,
             SUM(f.amount) as license_fee
      FROM licenses l
      INNER JOIN licensors lr ON (l.licensor_id = lr.id)
      LEFT JOIN license_fees f ON (l.id = f.license_id)
      INNER JOIN license_mappings m ON (m.license_id = l.id)
      LEFT JOIN plan_resources r
        ON (m.mappable_type = 'PlanResource' AND m.mappable_id = r.id)
      LEFT JOIN subscriptions s
        ON (s.plan_id = CASE WHEN m.mappable_type = 'Plan'
                             THEN m.mappable_id ELSE r.plan_id
                        END)
      LEFT JOIN accounts a ON (a.id = s.account_id)
      LEFT JOIN charges c on (c.subscription_id = s.id)
      WHERE c.operate_from BETWEEN ? AND ?
      GROUP BY lr.id, l.id, a.id
    SQL
  end

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
