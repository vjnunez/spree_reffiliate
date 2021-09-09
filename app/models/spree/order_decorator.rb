module Spree::OrderDecorator

  # por algun motivo no funciona en producción definir en el decorator el
  # state_machine.after_transition

  def self.prepended(base)
    base.include Spree::TransactionRegistrable

    base.has_many :transactions, as: :commissionable, class_name: 'Spree::CommissionTransaction', dependent: :restrict_with_error
    base.belongs_to :affiliate, class_name: 'Spree::Affiliate'

    # base.state_machine.after_transition to: :complete, do: :create_commission_transaction
  end
  
  private
    # def create_commission_transaction
    #   register_commission_transaction(affiliate) if affiliate.present?
    # end

  ::Spree::Order.prepend self

end
