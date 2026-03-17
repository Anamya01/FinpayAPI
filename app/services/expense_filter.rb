class ExpenseFilter
  def initialize(scope, params)
    @scope = scope
    @params = params
  end

  def call
    @scope.by_category(@params[:category_id])
          .by_status(@params[:status])
          .in_date_range(@params[:start_date], @params[:end_date])
  end
end
