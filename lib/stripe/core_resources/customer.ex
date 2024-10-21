defmodule Stripe.Customer do
  @moduledoc """
  Work with Stripe customer objects.

  You can:

  - Create a customer
  - Retrieve a customer
  - Update a customer
  - Delete a customer

  Stripe API reference: https://stripe.com/docs/api/customers
  """

  use Stripe.Entity
  import Stripe.Request

  @type t :: %__MODULE__{
          id: Stripe.id(),
          object: String.t(),
          address: Stripe.Types.address() | nil,
          balance: integer,
          cash_balance: Stripe.CashBalance.t() | nil,
          created: Stripe.timestamp(),
          currency: String.t() | nil,
          default_source: Stripe.id() | Stripe.Source.t() | nil,
          deleted: boolean | nil,
          delinquent: boolean | nil,
          description: String.t() | nil,
          discount: Stripe.Discount.t() | nil,
          email: String.t() | nil,
          invoice_prefix: String.t() | nil,
          invoice_settings: Stripe.Invoice.invoice_settings() | nil,
          livemode: boolean,
          metadata: Stripe.Types.metadata(),
          name: String.t(),
          next_invoice_sequence: integer,
          payment_method: String.t() | nil,
          phone: String.t(),
          preferred_locales: list(String.t()),
          shipping: Stripe.Types.shipping() | nil,
          sources: Stripe.List.t(Stripe.Source.t()),
          subscriptions: Stripe.List.t(Stripe.Subscription.t()),
          tax_exempt: String.t() | nil,
          tax_ids: Stripe.List.t(Stripe.TaxID.t())
        }

  defstruct [
    :id,
    :object,
    :address,
    :balance,
    :cash_balance,
    :created,
    :currency,
    :default_source,
    :deleted,
    :delinquent,
    :description,
    :discount,
    :email,
    :invoice_prefix,
    :invoice_settings,
    :livemode,
    :metadata,
    :name,
    :next_invoice_sequence,
    :payment_method,
    :phone,
    :preferred_locales,
    :shipping,
    :sources,
    :subscriptions,
    :tax_exempt,
    :tax_ids
  ]

  @plural_endpoint "customers"

  @doc """
  Create a customer.
  """
  @spec create(params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
        when params:
               %{
                 optional(:address) => Stripe.Types.address(),
                 optional(:balance) => integer,
                 optional(:coupon) => Stripe.id() | Stripe.Coupon.t(),
                 optional(:description) => String.t(),
                 optional(:email) => String.t(),
                 optional(:invoice_prefix) => String.t(),
                 optional(:invoice_settings) => Stripe.Invoice.invoice_settings(),
                 optional(:metadata) => Stripe.Types.metadata(),
                 optional(:name) => String.t(),
                 optional(:payment_method) => String.t(),
                 optional(:phone) => String.t(),
                 optional(:preferred_locales) => list(String.t()),
                 optional(:shipping) => Stripe.Types.shipping(),
                 optional(:source) => Stripe.id() | Stripe.Source.t(),
                 optional(:tax_excempt) => String.t(),
                 optional(:tax_id_data) => Stripe.TaxID.tax_id_data()
               }
               | %{}
  def create(params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint)
    |> put_params(params)
    |> put_method(:post)
    |> cast_to_id([:coupon, :default_source, :source])
    |> make_request()
  end

  @doc """
  Retrieve a customer.
  """
  @spec retrieve(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def retrieve(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:get)
    |> make_request()
  end

  @doc """
  Update a customer.
  """
  @spec update(Stripe.id() | t, params, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
        when params:
               %{
                 optional(:address) => Stripe.Types.address(),
                 optional(:balance) => integer,
                 optional(:coupon) => Stripe.id() | Stripe.Coupon.t(),
                 optional(:default_source) => Stripe.id() | Stripe.Source.t(),
                 optional(:description) => String.t(),
                 optional(:email) => String.t(),
                 optional(:invoice_prefix) => String.t(),
                 optional(:invoice_settings) => Stripe.Invoice.invoice_settings(),
                 optional(:metadata) => Stripe.Types.metadata(),
                 optional(:name) => String.t(),
                 optional(:phone) => String.t(),
                 optional(:preferred_locales) => list(String.t()),
                 optional(:shipping) => Stripe.Types.shipping(),
                 optional(:source) => Stripe.Source.t(),
                 optional(:tax_excempt) => String.t()
               }
               | %{}
  def update(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end

  @doc """
  Delete a customer.
  """
  @spec delete(Stripe.id() | t, Stripe.options()) :: {:ok, t} | {:error, Stripe.Error.t()}
  def delete(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}")
    |> put_method(:delete)
    |> make_request()
  end

  @doc """
  List all customers.
  """
  @spec list(params, Stripe.options()) :: {:ok, Stripe.List.t(t)} | {:error, Stripe.Error.t()}
        when params:
               %{
                 optional(:created) => String.t() | Stripe.date_query(),
                 optional(:email) => String.t(),
                 optional(:ending_before) => t | Stripe.id(),
                 optional(:limit) => 1..100,
                 optional(:starting_after) => t | Stripe.id()
               }
               | %{}
  def list(params \\ %{}, opts \\ []) do
    new_request(opts)
    |> prefix_expansions()
    |> put_endpoint(@plural_endpoint)
    |> put_method(:get)
    |> put_params(params)
    |> cast_to_id([:ending_before, :starting_after])
    |> make_request()
  end

  @doc """
  Deletes the discount on a customer
  """
  @spec delete_discount(Stripe.id() | t, Stripe.options()) ::
          {:ok, t} | {:error, Stripe.Error.t()}
  def delete_discount(id, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/discount")
    |> put_method(:delete)
    |> make_request()
  end

  @doc """
  A customer's Cash balance represents real funds.
  Customers can add funds to their cash balance by sending a bank transfer.
  These funds can be used to reconciliate PaymentIntents with source “cash_balance”.
  The settings[reconciliation_mode] field describes whether these funds
  are applied to such PaymentIntents manually or automatically.

  This function changes the settings on a customer’s cash balance.

  Example:  Change reconcilation mode to manual

    params = %{settings: %{reconciliation_mode: "manual"}}
    {:ok, cash_Balance} = Stripe.Customer.update_cash_balance("cus_123")

  """
  @spec update_cash_balance(Stripe.id() | t, params, Stripe.options()) ::
          {:ok, t} | {:error, Stripe.Error.t()}
        when params:
               %{
                 optional(:settings) => Stripe.Types.metadata()
               }
               | %{}
  def update_cash_balance(id, params, opts \\ []) do
    new_request(opts)
    |> put_endpoint(@plural_endpoint <> "/#{get_id!(id)}/cash_balance")
    |> put_method(:post)
    |> put_params(params)
    |> make_request()
  end
end
