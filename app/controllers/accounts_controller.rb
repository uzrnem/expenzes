class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :update, :destroy]

  # GET /accounts
  def index
    @accounts = Account.where(:is_closed => 0).order('name ASC')

    render json: @accounts
  end

  def frequent
    @accounts = Account.where(:is_closed => 0, is_frequent: 1).order('name ASC')
    render json: @accounts
  end

  def share
#select
# a.id, a.slug, t.name, a.amount, SUM(a.amount) OVER (PARTITION BY a.account_type_id ) as sum
#from accounts a
#left join account_types t on a.account_type_id = t.id
#where a.amount !=0 and a.is_snapshot_disable = 0
#order by a.account_type_id, a.slug;
    holding_balance_sql = "select
     t.name as 'Account', SUM(a.amount) as 'Amount per Account'
    from accounts a
    left join account_types t on a.account_type_id = t.id
    where a.amount !=0 and a.is_snapshot_disable = 0 and a.is_closed != 1
    group by a.account_type_id order by t.name='Saving' desc, t.name='Credit' desc, t.name='Wallet' desc,
    t.name='Stocks Equity' desc, t.name='Loan' desc, t.name='Mutual Funds' desc, t.name='Deposit' desc;";
    holding_balance = ApplicationRecord.connection.exec_query(holding_balance_sql)

    account_balance_sql = "select a.name as account, t.name as type, a.amount as balance
    from accounts a
    left join account_types t on a.account_type_id = t.id
    where a.amount !=0 and a.is_snapshot_disable = 0 and a.is_closed != 1
    order by t.name='Saving' desc, t.name='Credit' desc, t.name='Wallet' desc,
    t.name='Deposit' desc, t.name='Loan' desc, t.name='Stocks Equity', a.name;"
    account_balance = ApplicationRecord.connection.exec_query(account_balance_sql)

    ccBills = []
    #ccBills[0]['cat'] = 'feline'
    #a # => [{"cat"=>"feline"}, {}]
    total = 0.0
    ccIndex = 0
    ccBills.unshift(['Balance', total])

    array = holding_balance.rows
    array.each_with_index {|val, index|
      if val[1].to_f < 0
        ccBills.unshift(['CC Bill', 0 - val[1].to_f])
        ccIndex = index
      end
      total += val[1].to_f
      array[index][1] = val[1].to_f
      puts "#{val} => #{index}"
    }
    array.delete_at(ccIndex)
    ccBills[1][1] = total
    ccBills.unshift(holding_balance.columns)
    puts ccBills

    array.unshift(holding_balance.columns)

    render json: { holding: array, balance: account_balance, totalBalance: ccBills }
  end

  # GET /accounts/1
  def show
    render json: @account
  end

  # POST /accounts
  def create
    @account = Account.new(account_params)

    if @account.save
      render json: @account, status: :created, location: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /accounts/1
  def update
    if @account.update(account_params)
      render json: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  # DELETE /accounts/1
  def destroy
    @account.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_account
      @account = Account.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def account_params
      params.require(:account).permit(:name, :account_types_id, :amount)
    end
end
