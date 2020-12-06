class ActivitiesController < ApplicationController
  before_action :set_activity, only: [:show, :update, :destroy]

  # GET /activities
  def index
    sql = "SELECT act.id, act.amount, act.event_date, act.remarks, act.created_at, act.updated_at,
     fa.name as from_account, ta.name as to_account, tags.name as tag,
     transaction_types.name as transaction_type
    FROM `activities` as act
    LEFT JOIN `tags` ON `tags`.`id` = `act`.`tag_id`
    LEFT JOIN `transaction_types` ON `transaction_types`.`id` = `act`.`transaction_type_id`
    LEFT JOIN accounts as fa ON fa.id = act.from_account_id
    LEFT JOIN accounts as ta ON ta.id = act.to_account_id
    ORDER BY `act`.`event_date` DESC, `act`.`id` DESC LIMIT 15 -- OFFSET 0"
    @activities = ApplicationRecord.connection.exec_query(sql)

    render json: @activities
  end

  # GET /activities/1
  def show
    render json: @activity
  end

  # POST /transactions
  def create
    input_params = params.require(:activity).permit(:from_account_id, :to_account_id,
    :amount, :event_date, :remarks, :tag_id)
    transaction_type = 'transfer'
    if input_params[:from_account_id] == 0 || input_params[:from_account_id] == "0"
      input_params.delete(:from_account_id)
      transaction_type = 'credit'
    elsif input_params[:to_account_id] == 0 || input_params[:to_account_id] == "0"
      input_params.delete(:to_account_id)
      transaction_type = 'debit'
    end
    transactionType = TransactionType.find_by( slug: transaction_type);
    input_params[:transaction_type] = transactionType
    puts input_params

    @activity = Activity.new(input_params)
    if @activity.save
      render json: @activity, status: :created, location: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  # POST /activities
  def create1
    @activity = Activity.new(activity_params)
    if @activity.save
      render json: @activity, status: :created, location: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /activities/1
  def update
    if @activity.update(activity_params)
      render json: @activity
    else
      render json: @activity.errors, status: :unprocessable_entity
    end
  end

  # DELETE /activities/1
  def destroy
    @activity.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_activity
      @activity = Activity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def activity_params
      params.require(:activity).permit(:from_account_id, :to_account_id, :tags_id, :amount, :event_date, :remarks, :transaction_types_id)
    end
end
