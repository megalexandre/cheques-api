class CreateBordero
  def initialize(bordero_params)
    @bordero_params = bordero_params
  end

  def call
    ActiveRecord::Base.transaction do
      bordero = Bordero.create!(@bordero_params)
      bordero
    end
  end
end
