defmodule VexillaClientElixirTest do
  use ExUnit.Case
  doctest VexillaClientElixir

  test "fetches feature flags" do
    config = VexillaClientElixir.create_config(
      "https://streamparrot-feature-flags.s3.amazonaws.com",
      "staging"
    )

    flags = VexillaClientElixir.get_flags(config, "features")

    should_use_feature = VexillaClientElixir.should?(flags, "billing", "features")

    assert should_use_feature == false

  end

  # test "greets the world" do
  #   assert VexillaClientElixir.hello() == :world
  # end
end
