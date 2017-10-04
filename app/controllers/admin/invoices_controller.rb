class Admin::InvoicesController < Admin::BaseController
  before_action :find_invoice, except: [:index, :new, :create]

  def index
    invoices_scope = Invoice.all

    smart_listing_create :invoices,
                        invoices_scope,
                        partial: "admin/invoices/listing",
                        default_sort: { created_at: "desc" }
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
