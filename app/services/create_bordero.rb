class CreateBordero
  def initialize(bordero_params)
    @bordero_params = bordero_params
  end

  def call
    ActiveRecord::Base.transaction do
      Bordero.create!(@bordero_params)
    end
  end
end
