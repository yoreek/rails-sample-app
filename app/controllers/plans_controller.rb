# Plans controller
class PlansController < ApplicationController
  before_action :set_plan, except: [:index, :create]
  respond_to :html, :json

  def index
    @plan = Plan.includes(:plan_resources).all
    respond_with do |format|
      format.json { render json: @plan.as_json(include: :plan_resources) }
      format.html
    end
  end

  def create
    @plan = Plan.new(plan_params)
    if @plan.save
      render json: @plan.as_json, status: :ok
    else
      render json: { plan: @plan.errors }, status: :unprocessable_entity
    end
  end

  def show
    respond_with(@plan.as_json)
  end

  def update
    if @plan.update_attributes(plan_params)
      render json: @plan.as_json, status: :ok
    else
      render json: { plan: @plan.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    @plan.destroy
    render json: { status: :ok }
  end

  private

  def plan_params
    plan = params.require(:plan)

    unless plan.plan_resources.blank?
      plan.plan_resources_attributes = plan.plan_resources
      plan.delete('plan_resources')
    end

    plan.permit(
      :name,
      plan_rresources_attributes: [:id, :name, :amount, :plan_id]
    )
  end

  def set_plan
    @plan = Plan.find(params[:id])
    render json: { status: :not_found } unless @plan
  end
end
