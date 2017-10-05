class InvoicesController < ApplicationController
  before_action :find_invoice, except: [:index, :new, :create]

  def index
    invoices_scope = @current_organization.invoices

    smart_listing_create :invoices,
                        invoices_scope,
                        partial: "/invoices/listing",
                        default_sort: { date: "desc" },
                        page_sizes: [50, 100, 150, 200]
  end

  def show
    @stripe_invoice = @invoice.stripe_instance
  end

  private

  def find_invoice
    @invoice = Invoice.find params[:id]
  end

  def invoice_params
    params.require(:invoice).permit!
  end
end
