defmodule VexillaClientElixirTest do
  use ExUnit.Case
  # doctest VexillaClientElixir

  test "fetches feature flags" do
    config = VexillaClientElixir.create_config(
      "https://streamparrot-feature-flags.s3.amazonaws.com",
      "dev"
    )

    flags = VexillaClientElixir.get_flags(config, "features")

    should_use_feature = VexillaClientElixir.should?(flags, "billing", "b7e91cc5-ec76-4ec3-9c1c-075032a13a1a")

    assert should_use_feature == true

    should_use_working_gradual = VexillaClientElixir.should?(flags, "testingWorkingGradual", "b7e91cc5-ec76-4ec3-9c1c-075032a13a1a")

    assert should_use_working_gradual == true

    should_use_non_working_gradual = VexillaClientElixir.should?(flags, "testingNonWorkingGradual","b7e91cc5-ec76-4ec3-9c1c-075032a13a1a")

    assert should_use_non_working_gradual == false


  end

end
