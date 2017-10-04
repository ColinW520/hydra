class Stripe::InvoiceSyncWorker
  include Sidekiq::Worker
  # this runs every 5 minutes
  def perform
    Stripe::Invoice.list.each do |stripe_invoice|
      Invoice.where(stripe_id: stripe_invoice.id).first_or_create(
        amount_due: stripe_invoice.amount_due.to_i,
        attempt_count: stripe_invoice.attempt_count.to_i,
        attempted: stripe_invoice.attempted,
        billing: stripe_invoice.billing,
        charge_id: stripe_invoice.charge,
        closed: stripe_invoice.closed,
        currency: stripe_invoice.currency,
        customer_id: stripe_invoice.customer,
        date: Time.at(stripe_invoice.date),
        description: stripe_invoice.description,
        discount_code: stripe_invoice.discount,
        ending_balance: stripe_invoice.ending_balance.to_i,
        forgiven: stripe_invoice.forgiven,
        number: stripe_invoice.number,
        paid: stripe_invoice.paid,
        period_end: Time.at(stripe_invoice.period_end),
        period_start: Time.at(stripe_invoice.period_start),
        receipt_number: stripe_invoice.receipt_number,
        statement_descriptor: stripe_invoice.statement_descriptor,
        subscription_id: stripe_invoice.subscription,
        subtotal: stripe_invoice.ending_balance.to_i,
        total: stripe_invoice.ending_balance.to_i
      )
    end
  end
end
