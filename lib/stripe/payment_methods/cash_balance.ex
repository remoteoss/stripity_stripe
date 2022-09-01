defmodule Stripe.CashBalance do
  @moduledoc """
  Work with [Stripe `Cash Balance` objects](https://stripe.com/docs/api/cash_balance/object)
  """

  use Stripe.Entity

  @type t :: %__MODULE__{
          object: String.t(),
          available: available(),
          customer: String.t(),
          livemode: boolean,
          settings: settings()
        }

  @type settings :: %{
          reconciliation_mode: String.t()
        }

  @type available :: %{
          String.t() => non_neg_integer
        }

  defstruct [
    :object,
    :available,
    :customer,
    :livemode,
    :settings
  ]
end
