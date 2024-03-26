defmodule Stripe.TelemetryTest do
  use Stripe.StripeCase, async: true

  test "telemetry" do
    test_process = self()

    :ok =
      :telemetry.attach_many(
        "telemetry-test",
        [
          [:stripity_stripe, :request, :start],
          [:stripity_stripe, :request, :stop]
        ],
        fn name, measurements, _metadata, _ ->
          cond do
            :start in name ->
              send(test_process, :request_started)

            :stop in name ->
              send(test_process, {:request_stopped, measurements.duration})
          end
        end,
        nil
      )

    assert {:ok, %Stripe.Charge{}} = Stripe.Charge.update("ch_123", %{metadata: %{foo: "bar"}})
    assert_stripe_requested(:post, "/v1/charges/ch_123")

    assert_receive :request_started,
                   200,
                   "[:request, :start] telemetry event wasn't emitted after 200ms"

    assert_receive {:request_stopped, duration} when is_integer(duration),
                   200,
                   "[:request, :stop] telemetry event wasn't emitted after 200ms"
  end
end
