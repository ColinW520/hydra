class Stripe::InvoiceSyncWorker
  include Sidekiq::Worker
  # this runs every 5 minutes
  def perform
    Stripe::Invoice.list.each do |stripe_invoice|
      invoice = Invoice.where(stripe_id: stripe_invoice.id).first_or_initialize
      invoice.amount_due = stripe_invoice.amount_due.to_i
      invoice.attempt_count = stripe_invoice.attempt_count.to_i
      invoice.attempted = stripe_invoice.attempted
      invoice.billing = stripe_invoice.billing
      invoice.charge_id = stripe_invoice.charge
      invoice.closed = stripe_invoice.closed
      invoice.currency = stripe_invoice.currency
      invoice.customer_id = stripe_invoice.customer
      invoice.date = Time.at(stripe_invoice.date)
      invoice.description = stripe_invoice.description
      invoice.discount_code = stripe_invoice.try( =discount).try( =coupon).try( =id)
      invoice.ending_balance = stripe_invoice.ending_balance.to_i
      invoice.forgiven = stripe_invoice.forgiven
      invoice.number = stripe_invoice.number
      invoice.paid = stripe_invoice.paid
      invoice.period_end = Time.at(stripe_invoice.period_end)
      invoice.period_start = Time.at(stripe_invoice.period_start)
      invoice.receipt_number = stripe_invoice.receipt_number
      invoice.statement_descriptor = stripe_invoice.statement_descriptor
      invoice.subscription_id = stripe_invoice.subscription
      invoice.subtotal = stripe_invoice.subtotal.to_i
      invoice.total = stripe_invoice.total.to_i
      invoice.save!
    end

    puts "Synchronized the #{Stripe::Invoice.list.count} latest stripe invoices. \n\n"
  end
end
