module Spree::ClassStoreCreditDecorator
  Spree::StoreCredit::REFERRAL_STORE_CREDIT_CATEGORY = 'Referral Credit'
end

module Spree::StoreCreditDecorator

  def self.prepended(base)
    base.has_one :referred_record
    base.after_commit :send_credit_reward_information, on: :create, if: :referral?
  end
  
  private
  
    def referral?
      category.try(:name) == Spree::StoreCredit::REFERRAL_STORE_CREDIT_CATEGORY
    end

    def send_credit_reward_information
      Spree::ReferralMailer.credits_awarded(user, amount.to_f).deliver_later
    end

end

::Spree::StoreCredit.prepend(Spree::StoreCreditDecorator)
::Spree::StoreCredit.singleton_class.send :prepend, Spree::ClassStoreCreditDecorator
